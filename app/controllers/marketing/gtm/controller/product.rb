module Marketing
  module Gtm
    module Controller
      module Product
        extend ActiveSupport::Concern

        private

        def gtm_page_type
          'product'
        end

        def append_gtm_product(product_presenter)
          gtm_product = Marketing::Gtm::Presenter::Product.new(product_presenter: product_presenter)
          @gtm_container.append(gtm_product)
        end
      end
    end
  end
end
