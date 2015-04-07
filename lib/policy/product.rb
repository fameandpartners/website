# Container for product policy.
module Policy
  class Product
    attr_reader  :product

    def initialize(product)
      @product = product
    end

    def customisation_allowed?
      ! product.discount.present?
    end
  end
end
