module Marketing
  module Gtm
    module Presenter
      class Product < Base
        include ActionView::Helpers::SanitizeHelper

        attr_reader :product

        def initialize(product_presenter:)
          @product = product_presenter
        end

        def key
          'product'.freeze
        end

        def price
          product.price&.amount.to_f.round(2)
        end

        def price_with_discount
          product.price_amount.to_f.round(2)
        end
     
        def body
          {
              id:                product.id,
              productSku:        product.sku,
              name:              product.name,
              sku:               product.sku,
              price:             price.to_f,
              type:              product.type,
          }
        end
      end
    end
  end
end
