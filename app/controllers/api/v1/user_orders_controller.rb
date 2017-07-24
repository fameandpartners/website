module Api
  module V1
    class UserOrdersController < Users::OrdersController
      respond_to :json

      def index
        user = try_spree_current_user
        @orders = [Orders::OrderPresenter.new(Spree::LineItem.find(308535).order)]

        # @orders = user.orders.complete.map do |order|
        #   Orders::OrderPresenter.new(order)
        # end

        @orders

        respond_with @orders
      end
    end
  end
end
