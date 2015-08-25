module Products
  class RelatedPresenter
    attr_reader :recommended_products, :related_jackets

    def initialize(recommended_products: [], related_jackets: [])
      @recommended_products = recommended_products
      @related_jackets      = related_jackets
    end

    def recommended
      recommended_products.first(Products::DetailsResource::RECOMMENDED_PRODUCTS_LIMIT)
    end

    def jackets
      related_jackets.first(Products::DetailsResource::RELATED_JACKETS_LIMIT)
    end
  end
end
