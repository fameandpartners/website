class Repositories::VariantPrice
  #include Repositories::CachingSystem

  attr_reader :variant

  def initialize(options = {})
    @variant = options[:variant]
    @product = @variant.product
  end

  def read
    result = FastOpenStruct.new(
      id: variant.id,
      product_id: variant.product_id,
    )
  end

  # variant_price = Repositories::VariantPrice.new(variant: variant).read
  # variant_price[site_verson.permalink]
  def read
    FastOpenStruct.new(
      id: variant.id,
      product_id: variant.product_id,
      aud: { currency: 'aud', amount: 150 },
      usd: { currency: 'usd', amount: 150 }
    )
  end

  #cache_results :read

  private

    def variant_spree_prices
      @variant_spree_prices ||= Spree::Price.where(variant_id: variant.id).to_a
    end

    def variant_zone_prices
      @variant_zone_prices ||= Spree::ZonePrice.where(variant_id: variant.id).to_a
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

