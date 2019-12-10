module Api
  module V1
    class OrdersController < Api::ApiBaseController

      respond_to :json

      def history

        if params[:order_number].blank?

          orders = current_spree_user.orders
          puts "current_spree_user.orders"
          orders = orders.to_a
          puts orders.length
          orders.each do |od|
            puts od.to_s
          end
          orders = current_spree_user.orders.hydrated
          puts "current_spree_user.orders.hydrated"
          orders = orders.to_a
          puts orders.length
          orders.each do |od|
            puts od.to_s
          end
          orders = current_spree_user.orders.hydrated.complete.valid_orders
          puts "current_spree_user.orders.hydrated.complete"
          orders = orders.to_a
          puts orders.length
          orders.each do |od|
            puts od.to_s
          end

          @orders = orders
          respond_with @orders, each_serializer: OrderSerializer

        else

          @order = Spree::Order.hydrated.where(:number=>params[:order_number]).first
          respond_with @order, serializer: OrderSerializer

        end
      end
    end
  end
end
