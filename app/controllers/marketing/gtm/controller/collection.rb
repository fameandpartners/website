module Marketing
  module Gtm
    module Controller
      module Collection
        extend ActiveSupport::Concern

        private

        def gtm_page_type
          'collection'
        end

        def append_gtm_collection(product_collection)
          gtm_collection = Marketing::Gtm::Presenter::Collection.new(product_collection: product_collection)
          @gtm_container.append(gtm_collection)
        end
      end
    end
  end
end
