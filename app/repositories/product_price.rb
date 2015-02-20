# note
#   this objects more likely be Repositories::Price object
#   and should returns some custom 'price' object with discount, zone price, sale?
#
# Usage
#   Repositories::ProductPrice.new(site_version: current_site_version, product: product).read
#   Repositories::ProductPrice.new(product: product).read
#
class Repositories::ProductPrice
  include Repositories::CachingSystem

  attr_reader :site_version, :product

  def initialize(options = {})
    @product      = options[:product]
    @site_version = options[:site_version] || SiteVersion.default
  end

  def read
    product.zone_price_for(site_version)
  end

  cache_results :read

  private

    def cache_key
      "product-price-#{ site_version.permalink}-#{ product.permalink }"
    end
end
