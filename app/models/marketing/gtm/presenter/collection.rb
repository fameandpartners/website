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

        def sku(product)
          color_or_fabric = product.fabric&.name || product.color&.name

          "#{product.sku}~#{color_or_fabric}"
        end

        def body
          collection.products.map { |product|
            {
              id:           product.id,
              sku:          sku(product),
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
