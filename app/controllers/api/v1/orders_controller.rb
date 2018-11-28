module Api
  module V1
    class OrdersController < Api::ApiBaseController

      respond_to :json

      def history

        if params[:order_number].blank?

          @orders = current_spree_user.orders.joins(:line_items).eager_load(line_items: [:personalization, :variant, :item_return]).complete.map do |order|
            OrderSerializer.new(order).as_json
          end

          respond_with @orders

        else
          
          @order = Spree::Order.joins(:line_items).eager_load(line_items: [:personalization, :variant, :item_return]).where(:number=>params[:order_number]).first
          respond_with OrderSerializer.new(@order).as_json

        end
      end
    end
  end
end
