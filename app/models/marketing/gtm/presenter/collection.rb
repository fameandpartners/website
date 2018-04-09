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
              variant_skus: product.variant_skus,
              name:         product.name,
              price:        product.price&.amount,
              category:     product.type,
              position:     position
            }
          }
        end
      end
    end
  end
end
