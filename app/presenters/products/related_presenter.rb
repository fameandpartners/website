module Products
  class RelatedPresenter
    attr_reader :recommended_products, :related_outerwear

    def initialize(recommended_products: [], related_outerwear: [])
      @recommended_products = recommended_products
      @related_outerwear    = related_outerwear
    end

    def recommended
      recommended_products.first(Products::DetailsResource::RECOMMENDED_PRODUCTS_LIMIT)
    end

    def outerwear
      related_outerwear.first(Products::DetailsResource::RELATED_OUTERWEAR_LIMIT)
    end
  end
end
