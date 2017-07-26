module Api
  module V1
    class ReturnsProcessController < Users::OrdersController
      respond_to :json

      def index
        user = try_spree_current_user

        @orders = user.orders.complete.map do |order|
          Orders::OrderPresenter.new(order)
        end

        respond_with @orders
      end
    end
  end
end
