module Api
  module V1
    class OrdersController < Api::ApiBaseController

      respond_to :json

      def history
        if current_spree_user.nil?
          return
        end

        @orders = current_spree_user.orders.joins(:line_items).eager_load(line_items: [:personalization, :variant, :item_return]).complete.map do |order|
          #Orders::OrderPresenter.new(order, order.line_items)
          OrderSerializer.new(order).as_json.merge({ items: order.line_items })
        end

        respond_with @orders
      end
    end
  end
end
