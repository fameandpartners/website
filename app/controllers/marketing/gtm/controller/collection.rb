module Marketing
  module Gtm
    module Controller
      module Collection
        extend ActiveSupport::Concern

        private

        def gtm_page_type
          'collection'
        end

        def append_gtm_collection(collection_presenter)
          gtm_collection = Marketing::Gtm::Presenter::Collection.new(collection_presenter: collection_presenter)
          @gtm_container.append(gtm_collection)
        end
      end
    end
  end
end
