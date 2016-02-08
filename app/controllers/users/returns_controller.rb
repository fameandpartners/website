class Users::ReturnsController < Users::BaseController
  attr_reader :order_return, :user
  helper_method :order_return, :user

  def new
    order_number = params[:order_number]

    @user = try_spree_current_user

    order = if user.has_spree_role?(:admin)
      Spree::Order.find_by_number(order_number)
    else
      user.orders.where(number: order_number).first
    end

    if order.present?
      @order_return = OrderReturnRequest.new(:order => order)
      @order_return.build_items

      @title = "Order ##{ @order_return.number }"
    else
      err = ActiveRecord::RecordNotFound.new("Missing expected Spree::Order for Return number='#{order_number}'")

      NewRelic::Agent.notice_error(err)
      redirect_to user_orders_path, { flash: { error: "Sorry Babe, we couldn't find the Order: '#{order_number}'"} }
    end
  end

  def create
    @user = try_spree_current_user

    unless user.has_spree_role?(:admin)
      if user != order.user
        # NewRelic::Agent.notice_error(err)
        redirect_to user_orders_path, { flash: { error: "Sorry Babe, we couldn't find your Order: '#{order_number}'"} }
      end
    end

    @order_return = OrderReturnRequest.new(params[:order_return_request])
    if @order_return.save
      OrderReturnRequestMailer.email(@order_return, user).deliver unless user.has_spree_role?(:admin)
      render 'success'
    else
      @title = "Order ##{ @order_return.number }"
      render 'new'
    end
  end

end
