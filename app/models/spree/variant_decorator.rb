Spree::Variant.class_eval do
  delegate_belongs_to :final_price, :price_without_discount if Spree::Price.table_exists?

  has_many :zone_prices, :dependent => :destroy

  attr_accessible :zone_prices_hash
  attr_accessor :zone_prices_hash

  after_save :update_zone_prices

  def in_sale?
    current_sale.active?
  end

  def options_hash
    values = self.option_values.joins(:option_type).order("#{Spree::OptionType.table_name}.position asc")

    Hash[*values.map{ |ov| [ov.option_type.presentation, ov.presentation] }]
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

    zone_prices = self.zone_prices.where(zone_id: zone.id)
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

  private

  def current_sale
    @current_sale ||= Spree::Sale.first_or_initialize
  end
end
