Spree::OrdersController.class_eval do
  include Marketing::Gtm::Controller::Order
  include Marketing::Gtm::Controller::Event
  before_filter :load_quaypay_payment, only: [:quadpay_confirm, :quadpay_cancel]  #源代码为before_action
  layout 'redesign/application', only: :show

  attr_reader :order
  helper_method :order

  # Ensure that we get people to login instead of giving them $20 off by 404ing.
  rescue_from CanCan::AccessDenied do
    redirect_to spree.login_path
  end

  # todo: merge order & user_cart => completed order resource
  def show
    # this is a security hole
    order = ::Spree::Order.find_by_number!(params[:id])

    @spree_order = order
    @order = Orders::OrderPresenter.new(order)

    append_gtm_order(spree_order: order, base_url: root_url)
    append_gtm_event(event_name: :completed_order) if flash[:commerce_tracking]

    respond_with(@order)
  end

  # Shows the current incomplete order from the session
  def edit
    # temporarily? disabled /cart page
    redirect_to(dresses_path) and return

    # @order = current_order(true)
    # associate_user

    # only line items. for now
    # @user_cart = Repositories::UserCart.new(
    #   accessor: current_spree_user,
    #   order: @order,
    #   site_version: current_site_version
    # ).read

    # title('Your Shopping Cart', default_seo_title)
  end

  def update
    @order = current_order
    unless @order
      flash[:error] = t(:order_not_found)
      redirect_to root_path and return
    end

    if @order.update_attributes(params[:order])
      if params[:order] && params[:order].has_key?(:coupon_code)
        if params[:order][:coupon_code].present? && apply_coupon_code
          @order.reload

          respond_with(@order) do |format|
            format.js{ render 'spree/orders/coupon_code/success' }
          end
        else
          respond_with(@order) do |format|
            format.js{ render 'spree/orders/coupon_code/failure' }
          end
        end

        return
      end

      @order.line_items = @order.line_items.select {|li| li.quantity > 0 }
      fire_event('spree.order.contents_changed')
      respond_with(@order) do |format|
        format.html do
          if params.has_key?(:checkout)
            @order.next_transition.try(:run_callbacks)
            @order.next if @order.state.eql?('cart')
            redirect_to checkout_path
          else
            redirect_to cart_path
          end
        end
      end
    else
      respond_with(@order)
    end
  end
  def quadpay_confirm
    if @quadpay_order.body['orderStatus'] == 'Approved'
      @payment.complete!
      # Force complete order
      while @order.next; end

      if @order.completed?
        @current_order = nil
        flash['order_completed'] = true
        flash[:notice] = "#{Spree.t(:quadpay_payment_success)} #{Spree.t(:order_processed_successfully)}"
        return go_to_order_page
      else
        flash[:error] = Spree.t(:quadpay_payment_fail, number: @order.number)
        return redirect_to checkout_state_path(@order.state)
      end
    else
      flash[:error] = Spree.t(:quadpay_payment_fail, number: @order.number)
    end
    return go_to_order_page
  end

  def quadpay_cancel
    flash[:notice] = Spree.t(:quadpay_payment_cancelled)
    return go_to_order_page
  end

  private
  def go_to_order_page
    # Because order was completed, so customer must be redirect to order's show page or
    # if order not found we will redirect customer to root page
    url =
      if @payment && @order && @order.complete?
        order_path(@payment.order)
      else
        cart_path
      end
    redirect_to url
  end

  def load_quaypay_payment
    @payment = Spree::Payment.find_by(response_code: params['token'])
    if @payment
      @order = @payment.order
      @quadpay_order = @payment.payment_method.find_order(params['token'])
      if @quadpay_order # log payment
        @payment.log_entries.create(
          details: ActiveMerchant::Billing::Response.new(
            @quadpay_order.code == 200,
            @quadpay_order.body).to_yaml
        )
      end
    end

    return if @quadpay_order && @quadpay_order.code == 200 # keep processing if request success
    flash[:notice] = Spree.t(:quadpay_payment_cancelled)
    go_to_order_page
  end
  private

  def check_authorization
    access_token = params[:token] || session[:access_token]

    order = Spree::Order.find_by_number(params[:id]) || current_order

    if order
      authorize! :edit, order, access_token
    else
      authorize! :create, Spree::Order
    end
  end
end
