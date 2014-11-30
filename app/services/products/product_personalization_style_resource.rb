class Products::ProductPersonalizationStyleResource
  attr_reader :site_version, :product

  def initialize(options = {})
    @site_version     = options[:site_version]
    @product          = options[:product]
  end

  def cache_key
    "product-personalization-style-#{ product.permalink }"
  end

  def cache_expiration_time
    return configatron.cache.expire.quickly if Rails.env.development?
    return configatron.cache.expire.quickly if Rails.env.staging?
    return configatron.cache.expire.long
  end

  def read
    Rails.cache.fetch(cache_key, expires_in: cache_expiration_time) do
      # product details
      t = OpenStruct.new({
        id: product.id,
        sku:  product.sku,
        name: product.name,
        price: product.price,
        permalink: product.permalink,
        short_description: product.short_description,
        styles: product_styles
      })
    end
  end

  private


    def product_styles
      @product_styles ||= begin
        Products::ProductStyleAccessoriesResource.new(product: product, site_version: site_version).read
      end
    end
end
