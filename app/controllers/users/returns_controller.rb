class Users::ReturnsController < Users::BaseController
  attr_reader :order_return, :user
  helper_method :order_return, :user

  def new
    @reasons = ReturnRequestItem::REASON_CATEGORY_MAP.to_json

    order_number = params[:order_number]

    @user = try_spree_current_user

    # TODO: this scoping should be controlled by authorization objects
    order = if user.has_spree_role?(:admin)
      Spree::Order.find_by_number(order_number)
    else
      user.orders.where(number: order_number).first
    end

    if order.present?
      @order_return = OrderReturnRequest.find_by_order_id( order.id ) || OrderReturnRequest.new(:order => order)
      @order_return.build_items

      @title = "Order ##{ @order_return.number }"
    else
      err = ActiveRecord::RecordNotFound.new("Missing expected Spree::Order for Return number='#{order_number}'")

      NewRelic::Agent.notice_error(err)
      redirect_to user_orders_path, { flash: { error: "Sorry Babe, we couldn't find the Order: '#{order_number}'"} }
    end
  end

  # TODO: need spec
  def create
    @user         = try_spree_current_user
    @order_return = OrderReturnRequest.new(params[:order_return_request])
    @order        = Spree::Order.find(params[:order_return_request][:order_id])

    # TODO: this verification should be done via cancan (or any authorization method)
    unless @user.has_spree_role?(:admin)
      if @user != @order.user
        # NewRelic::Agent.notice_error(err)
        redirect_to user_orders_path, { flash: { error: "Sorry Babe, we couldn't find your Order: '#{order_number}'"} }
      end
    end

    if @order_return.save
      start_bergen_return_process(@order_return)
      start_next_logistics_process(@order_return)
      OrderReturnRequestMailer.email(@order_return, user).deliver
      render 'success'
    else
      redirect_to :controller => "users/returns", :action => "new", :order_number => @order.number
    end
  end

  private

  def start_bergen_return_process(order_return)
    order_return.return_request_items.each do |rri|
      Bergen::Operations::ReturnItemProcess.new(return_request_item: rri).start_process
    end
  end

  def start_next_logistics_process(order_return)
    if Features.active?(:next_logistics)
      NextLogistics::ReturnRequestProcess.new(order_return_request: order_return).start_process
    end
  end
end
