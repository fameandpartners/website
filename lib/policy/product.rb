# Container for product policy.
module Policy
  class Product
    attr_reader  :product

    def initialize(product)
      @product = product
    end

    def customisation_allowed?
      product.discount.blank? || product.discount.customisation_allowed
    end
  end
end
