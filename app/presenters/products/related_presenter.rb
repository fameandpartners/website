module Products
  class RelatedPresenter
    attr_reader :recommended_products, :related_jackets

    def initialize(recommended_products: [], related_jackets: [])
      @recommended_products = recommended_products
      @related_jackets      = related_jackets
    end

    def recommended
      recommended_products.first(recommended_products_count)
    end

    def jackets
      related_jackets.first(related_jackets_count)
    end

    private

    def related_jackets_count
      [related_jackets.count, Products::DetailsResource::RELATED_JACKETS_LIMIT].min
    end

    def recommended_products_count
      recommended_products.count - related_jackets_count
    end
  end
end
