module Api
  module V1
    class OrdersController < Api::ApiBaseController

      respond_to :json

      def history

        if params[:order_number].blank?

          @orders = current_spree_user.orders.hydrated.complete
          respond_with @orders, each_serializer: OrderSerializer

        else
          
          @order = Spree::Order.hydrated.where(:number=>params[:order_number]).first
          respond_with @order, serializer: OrderSerializer

        end
      end
    end
  end
end
