class Users::OrdersController < Users::BaseController
  def index
    user = try_spree_current_user
    @orders = user.orders

    respond_with(@orders) do |format|
      format.html {}
      format.js   {}
    end
  end

  def show
    user = try_spree_current_user
    @order = user.orders.where(number: params[:id]).first

    respond_with(@order) do |format|
      format.html { }
      format.js   { }
    end
  end
end
