module Marketing
  module Gtm
    module Controller
      module Product
        extend ActiveSupport::Concern

        included do
          before_filter { self.gtm_page_type = 'product'.freeze }
        end

        private

        def append_gtm_product(product_presenter)
          gtm_product = Marketing::Gtm::Presenter::Product.new(product_presenter: product_presenter)
          @gtm_container.append(gtm_product)
        end
      end
    end
  end
end
