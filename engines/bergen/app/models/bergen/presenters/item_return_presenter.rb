module Bergen
  module Presenters
    class ItemReturnPresenter
      attr_accessor :item_return

      def initialize(item_return:)
        @item_return = item_return
      end

      def rejected?
        item_return.bergen_damaged_quantity > 0
      end

      def accepted?
        !rejected? && item_return.bergen_actual_quantity > 0
      end
    end
  end
end
