require 'admin_ui/engine'

module Bergen
  module Presenters
    class ItemReturnPresenter
      extend Forwardable

      attr_accessor :item_return

      def_delegators :item_return,
                     :order_number,
                     :bergen_asn_number

      def initialize(item_return:)
        @item_return = item_return
      end

      def rejected?
        item_return.bergen_damaged_quantity > 0
      end

      def accepted?
        !rejected? && item_return.bergen_actual_quantity > 0
      end

      def admin_ui_url
        AdminUi.railtie_routes_url_helpers.item_return_path(item_return)
      end
    end
  end
end
