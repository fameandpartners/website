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
          { not_used_yet: true }

          # TODO: This collection mapping is useful for Criteo. It's EXTREMELY important for Criteo that Products' IDs match feed IDs
          # collection.products.map do |product|
          #   {
          #       id:   product.id,
          #       name: product.name
          #   }
          # end
        end
      end
    end
  end
end
