Spree::OrdersController.class_eval do
  layout 'redesign/application', only: :show

  # Ensure that we get people to login instead of giving them $20 off by 404ing.
  rescue_from CanCan::AccessDenied do
    redirect_to spree.login_path
  end

  # todo: merge order & user_cart => completed order resource
  def show
    @order = ::Spree::Order.find_by_number!(params[:id])
    @user_cart = ::UserCart::UserCartResource.new(order: @order).read
    respond_with(@order)
  end

  # Shows the current incomplete order from the session
  def edit
    # temporarily? disabled /cart page
    redirect_to(dresses_path) and return

    @order = current_order(true)
    associate_user

    # only line items. for now
    @user_cart = Repositories::UserCart.new(
      accessor: current_spree_user,
      order: @order,
      site_version: current_site_version
    ).read

    title('Your Shopping Cart', default_seo_title)
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
