module Marketing
  module Gtm
    module Presenter
      class Collection < Base
        attr_reader :collection

        def initialize(product_collection:)
          @collection = product_collection
        end

        def key
          'collection'.freeze
        end

        def body
          collection.products.map do |product|
            {
                product: {
                    id:   product.id,
                    name: product.name
                }
            }
          end
        end
      end
    end
  end
end
