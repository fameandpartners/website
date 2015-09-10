module Products
  module Concerns
    module Gtm
      extend ActiveSupport::Concern

      GTM_PRODUCT_PAGE_TYPE = 'product'

      included do
        before_filter { @gtm_page_type = GTM_PRODUCT_PAGE_TYPE }
      end

      private

      def append_gtm_product(product_presenter)
        gtm_product = Marketing::Gtm::ProductPresenter.new(product_presenter: product_presenter)
        @gtm_container.append(gtm_product)
      end
    end
  end
end
