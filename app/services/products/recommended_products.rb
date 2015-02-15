# usage
#   Products::RecommendedProducts.new(product: product, limit: limit).read
class Products::RecommendedProducts
  attr_reader :product, :limit

  def initialize(options = {})
    @product  = options[:product]
    @limit    = options[:limit] || 3
  end

  def read
    @recommended_products ||= Spree::Product.where(id: recommended_products_ids).limit(limit)
  end

  private

    def recommended_products_ids
      Rails.cache.fetch(cache_key, expires_in: cache_expiration_time) do
        recommended_products.map(&:id)
      end
    end

    def cache_key
      "product-personalization-style-#{ product.permalink }-limit-#{ limit }"
    end

    def cache_expiration_time
      return configatron.cache.expire.quickly if Rails.env.development?
      return configatron.cache.expire.quickly if Rails.env.staging?
      return configatron.cache.expire.long
    end

    def recommended_products
      recommended_products = Products::SimilarProducts.new(product).fetch(limit).to_a
      recommended_products += find_required(recommended_products, Spree::Product.active.featured)
      recommended_products += find_required(recommended_products, Spree::Product.active)

      recommended_products
    end

    def find_required(products, scope)
      products_required = limit - products.size
      return [] if products_required <= 0

      if products.present?
        scope = scope.where("spree_products.id not in (?)", products.map(&:id))
      end

      scope.limit(products_required).to_a
    end
end
