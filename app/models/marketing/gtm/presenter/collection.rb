module Marketing
  module Gtm
    module Presenter
      class Collection < Base
        attr_reader :collection

        def initialize(collection_presenter:)
          @collection = collection_presenter
        end

        def key
          'collection'.freeze
        end

        def body
          position = -1
          collection.products.map { |product|
            position += 1
            {
              id:           product.id,
              sku:          product.sku,
              productSku:   product.sku,
              name:         product.name,
              price:        product.price.amount,
              type:         product.type,
            }
          }
        end
      end
    end
  end
end
