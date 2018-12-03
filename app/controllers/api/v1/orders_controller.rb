module Api
  module V1
    class OrdersController < Api::ApiBaseController

      respond_to :json

      def history

        if params[:order_number].blank?

          @orders = current_spree_user.orders.hydrated.complete.map do |order|
            OrderSerializer.new(order).as_json
          end

          respond_with @orders

        else
          
          @order = Spree::Order.hydrated.where(:number=>params[:order_number]).first
          respond_with OrderSerializer.new(@order).as_json

        end
      end
    end
  end
end
