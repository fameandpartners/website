Spree::Variant.class_eval do
  has_one :discount, foreign_key: :variant_id
  has_many :style_to_product_height_range_groups, foreign_key: "style_number", primary_key: "sku"

  accepts_nested_attributes_for :prices


  attr_accessible :product_factory_name, :prices_attributes

  after_initialize :set_default_values

  before_validation :set_default_sku

  before_save :push_prices_to_variants
  
  def discount
    self.product.try(:discount)
  end

  def in_sale?
    discount.present?
  end

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

  def set_default_sku
    if self.sku.blank?
      self.sku = generate_sku
    end
  end

  def generate_sku
    ::VariantSku.new(self).call
  end

  # logic
  # Find a price in the site's currency
  def zone_price_for(zone_or_site_version)
    if zone_or_site_version.is_a?(Spree::Zone)
      site_price_for(zone_or_site_version.site_version)
    else
      site_price_for(zone_or_site_version)
    end
  end
  deprecate :zone_price_for

  def site_price_for(site_version)
    default_currency = Spree::Config.currency
    get_price_in(site_version.currency) || get_price_in(default_currency) || default_price
  end

  # NOTE: this differs from spree version by '|| prices.first'
  # for case, if we use price_in for site_version with another currency
  def price_in(currency)
    get_price_in(currency) || prices.first || Spree::Price.new(:variant_id => self.id, :currency => currency)
  end

  def get_price_in(currency)
    prices.find { |price| price.currency == currency }
  end

  def product_factory_name
    if product.property('factory_name').present?
      return product.property('factory_name').downcase
    end
  end

  private

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
      @size_option_type = Spree::OptionType.includes(:option_values).where(name: 'dress-size').first
    end

    def color_option_type
      @color_option_type = Spree::OptionType.includes(:option_values).where(name: 'dress-color').first
    end
  end

  # Used as a callback, so must return a truthy value to avoid breaking the save
  def push_prices_to_variants
    return :not_master unless is_master
    return :price_not_changed unless prices.any?(&:changed?)

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
