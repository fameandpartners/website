module Marketing
  module Gtm
    module Controller
      module Order
        extend ActiveSupport::Concern

        private

        def gtm_page_type
          'order'
        end

        def append_gtm_order(spree_order:, action_dispatch_request: nil)
          gtm_order = Marketing::Gtm::Presenter::Order.new(spree_order: spree_order, action_dispatch_request: action_dispatch_request)
          @gtm_container.append(gtm_order)
        end
      end
    end
  end
end
