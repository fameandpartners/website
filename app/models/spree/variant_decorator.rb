Spree::Variant.class_eval do
  delegate_belongs_to :final_price, :price_without_discount if Spree::Price.table_exists?

  has_many :zone_prices, :dependent => :destroy
  has_one :discount, foreign_key: :variant_id

  accepts_nested_attributes_for :prices

  attr_accessible :zone_prices_hash, :product_factory_name, :prices_attributes
  attr_accessor :zone_prices_hash

  #after_save :update_zone_prices
  after_initialize :set_default_values

  before_validation :set_default_sku

  before_save :push_prices_to_variants

  after_save do
    product.update_index
  end

  def save_default_price
    # store price dependendent
    #self.price = Services::VariantPriceCalculator.new(self).get

    if default_price && (default_price.changed? || default_price.new_record?)
      default_price.save
    end

    update_zone_prices
  end

  def discount
    self.product.try(:discount)
  end

  def in_sale?
    #current_sale.active?
    discount.present?
  end

  def fast_delivery
    return false if self.on_demand?
    self.count_on_hand > 0
  end
  alias_method :fast_delivery?, :fast_delivery

  def options_hash
    values = self.option_values.joins(:option_type).order("#{Spree::OptionType.table_name}.position asc")

    Hash[*values.map{ |ov| [ov.option_type.presentation, ov.presentation] }]
  end

  def dress_color
    @dress_color ||= get_option_value(self.class.color_option_type)
  end

  def dress_size
    @dress_size ||= get_option_value(self.class.size_option_type)
  end

  def get_option_value(option_type)
    return nil unless option_type
    self.option_values.detect do |option|
      option.option_type_id == option_type.id
    end
  end

  # Master SKU + VarientValue1 + VarientValue2
  def set_default_sku
    return if self.sku.present?

    if (sku = generate_sku).present?
      self.sku = sku
    end
  end

  def generate_sku
    return sku if is_master?

    sku_chunks = []
    master = nil

    if product.master.present?
      master = product.master
    elsif product.variants.present?
      master = product.variants.first
    end

    if master && master.sku.present?
      sku_chunks.push(master.sku)
    else
      sku_chunks.push(product.permalink)
    end

    self.option_values.sort_by(&:id).each do |value|
      name = value.option_type.name.sub(/^dress-/, '').try(:capitalize)
      chunk = "#{name}:#{value.presentation}"
      sku_chunks.push(chunk)
    end

    sku_chunks.reject(&:blank?).join('-')
  rescue
    nil
  end

  def generate_sku!
    if (sku = generate_sku).present?
      update_column(:sku, sku)
    end
  end


  #{"3"=>{"amount"=>"", "currency"=>""}, "2"=>{"amount"=>"62.0", "currency"=>"AUD"}}
  # or take from self.zone_prices_hash
  def update_zone_prices(zone_prices_attrs = {})
    zone_prices_attrs ||= self.zone_prices_hash
    if zone_prices_attrs.present?
      SiteVersion.where("currency != ?", Spree::Config.currency).each do |site_version|
        price = self.zone_prices.where(zone_id: site_version.zone_id).first_or_initialize
        attrs = (zone_prices_attrs[site_version.zone_id.to_s] || {}).merge(currency: site_version.currency)
        if attrs[:amount].blank?
          price.try(:destroy)
        else
          price.assign_attributes(attrs)
          price.save
        end
      end
    end
  end

  # logic
  # priorities
  # - ZonePrice for zone with site_version's currency
  # - any ZonePrice for zone
  # - Spree::Price for product in site_version's currency
  # - Spree::Price in default currency
  #
  # - if result price not in required currency, convert it
  def zone_price_for(zone_or_site_version)
    if zone_or_site_version.is_a?(Spree::Zone)
      zone = zone_or_site_version
    else
      zone = zone_or_site_version.zone
    end
    default_currency = Spree::Config.currency
    currency = zone.site_version.present? ? zone.site_version.currency : Spree::Config.currency

    zone_prices = self.zone_prices.select { |zp| zp.zone_id == zone.id }
    zone_price = zone_prices.select{|p| p.currency == currency }.first
    if zone_price.blank? && currency != default_currency
      zone_price = zone_prices.select{|p| p.currency == default_currency }.first
    end

    zone_price ||= (get_price_in(currency) || get_price_in(default_currency) || default_price)

    zone_price = zone_price.to_spree_price

    zone_price.convert_to(currency)
  end

  # NOTE: this differs from spree version by '|| prices.first'
  # for case, if we use price_in for site_version with another currency
  def price_in(currency)
    prices.select{ |price| price.currency == currency }.first || prices.first || Spree::Price.new(:variant_id => self.id, :currency => currency)
  end

  def get_price_in(currency)
    prices.select{ |price| price.currency == currency }.first
  end

  def product_factory_name
    if product.property('factory_name').present?
      return product.property('factory_name').downcase
    end
  end

  def product_plus_size
    is_plus = product.taxons.where(:name =>"Plus Size").first
    return true if is_plus
  end

  private

  def current_sale
    @current_sale ||= Spree::Sale.first_or_initialize
  end

  def set_default_values
    if self.new_record?
      self.on_demand     = true
      self.count_on_hand = 10
    end
  end

  def recalculate_product_on_hand
    on_hand = product(true).on_hand
    if Spree::Config[:track_inventory_levels] && on_hand != (1.0 / 0) # Infinity
      product.update_column(:count_on_hand, on_hand)
    end
  end

  class << self
    def size_option_type
      @size_option_type ||= Spree::OptionType.includes(:option_values).where(name: 'dress-size').first
    end

    def color_option_type
      @color_option_type ||= Spree::OptionType.includes(:option_values).where(name: 'dress-color').first
    end
  end

  # Used as a callback, so must return a truthy value to avoid breaking the save
  def push_prices_to_variants
    return :not_master unless is_master
    master_price_data = extract_price_data

    product.variants.each do |v|
      variant_price_data = v.extract_price_data
      next if variant_price_data == master_price_data

      prices.each do |master_price|
        variant_price = v.prices.where(currency: master_price.currency).first_or_initialize

        # TODO - If we ever move to variants with different prices to the master
        #        ( e.g. variants with extra price for extra sizes or explicit variants
        #        for custom colours ) then this code will need to be cleverer about not
        #        assuming all prices on all variants should be the same. (See diff)
        variant_price.amount = master_price.amount
        variant_price.save
      end
    end

    :completed
  end

  protected def extract_price_data
    prices.collect {|p| [p.currency, p.amount] }.sort_by(&:first)
  end
end
