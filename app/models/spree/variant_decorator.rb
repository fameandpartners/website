Spree::Variant.class_eval do
  delegate_belongs_to :default_price, :display_price, :display_amount, :price, :price=, :currency, :final_price, :price_without_discount if Spree::Price.table_exists?

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
      SiteVersion.where(default: false).each do |site_version|
        price = self.zone_prices.where(zone_id: site_version.zone_id).first_or_initialize
        price.assign_attributes(zone_prices_attrs[site_version.zone_id.to_s] || {})
        price.save 
      end
    end
  end

  def zone_price_for(zone)
    if zone.site_version.blank? || zone.site_version.default?
      return default_price
    end
    zone_price = self.zone_prices.where(zone_id: zone.id).first

    if !self.is_master? && zone_price.blank?
      master_variant = Spree::Product.find(self.product_id).master
      zone_price = master_variant.zone_prices.where(zone_id: zone.id).first
    end

    if zone_price.present?
      Spree::Price.new(zone_price.attributes.except(*%w{id zone_id}))
    else
      default_price
    end
  end

  private

  def current_sale
    @current_sale ||= Spree::Sale.first_or_initialize
  end
end
