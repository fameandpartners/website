# note
#   this objects more likely be Repositories::Price object
#   and should returns some custom 'price' object with discount, zone price, sale?
#
# Usage
#   Repositories::ProductPrice.new(site_version: current_site_version, product: product).read
#   Repositories::ProductPrice.new(product: product).read
#
# TODO - BURN THIS WITH FIRE
class Repositories::ProductPrice
  include Repositories::CachingSystem

  attr_reader :site_version

  def initialize(options = {})
    if options[:product].present?
      @product      = options[:product]
      @product_id   = @product.id
    else
      @product_id   = options[:product_id]
    end

    @site_version = options[:site_version] || SiteVersion.default
  end

  def read
    product.zone_price_for(site_version)
  end

  cache_results :read

  private

    def product
      @product ||= begin
        if @product_id.present?
          Spree::Product.find(@product_id)
        end
      end
    end

    def cache_key
      "product-price-#{ site_version.permalink}-#{ @product_id }"
    end
end
