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
          collection.products.map { |product|
            {
              sku: product.sku,
              name: product.name
            }
          }
        end
      end
    end
  end
end
