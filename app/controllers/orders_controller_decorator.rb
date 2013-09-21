Spree::OrdersController.class_eval do
  def guest
    @order = current_order(true)
    associate_user
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
