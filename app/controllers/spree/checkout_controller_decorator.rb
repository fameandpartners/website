Spree::CheckoutController.class_eval do
  before_filter :prepare_order, only: :edit
  before_filter :find_payment_methods, only: [:edit, :update]
  skip_before_filter :check_registration

  layout 'redesign/application'

  # update - address/payment
  def update
    move_order_from_cart_state(@order)

    if @order.state == 'address'
      # update first/last names, email
      registration = Services::UpdateUserRegistrationForOrder.new(@order, try_spree_current_user, params)
      registration.update
      if registration.new_user_created?
        fire_event("spree.user.signup", order: current_order)
        sign_in :spree_user, registration.user
      end
      if !registration.successfull?
        respond_with(@order) do |format|
          format.html { redirect_to checkout_state_path(@order.state) }
          format.js   { render 'spree/checkout/registration/failed' }
        end
        return
      end
    end

    if @order.update_attributes(object_params)

      fire_event('spree.checkout.update')
      if object_params.key?(:coupon_code)
        if object_params[:coupon_code].present? && apply_coupon_code
          @order.reload

          respond_with(@order) do |format|
            format.js{ render 'spree/checkout/coupon_code/success' }
          end
        else
          respond_with(@order) do |format|
            format.js{ render 'spree/checkout/coupon_code/failure' }
          end
        end

        return
      end

      if @order.next
        state_callback(:after)
      else
        flash[:error] = t(:payment_processing_failed)
        respond_with(@order) do |format|
          format.html{ redirect_to checkout_state_path(@order.state) }
          format.js{ render 'spree/checkout/update/failed' }
        end
        return
      end

      # with 'cart checkout' by paypal express we can return to fill address
      if @order.state == 'payment' && @order.has_checkout_step?('payment')
        state_callback(:before)
        if @order.next
          state_callback(:after)
        else
          @order.errors.delete(:state)
        end
      end

      if @order.state == 'complete' || @order.completed?
        flash.notice = t(:order_processed_successfully)
        flash[:commerce_tracking] = 'nothing special'

        session[:successfully_ordered] = true

        respond_with(@order) do |format|
          format.html{ redirect_to completion_route }
          format.js{ render 'spree/checkout/complete' }
        end
      else
        respond_with(@order) do |format|
          format.html{ redirect_to checkout_state_path(@order.state) }
          format.js{ render 'spree/checkout/update/success' }
        end
      end
    else
      respond_with(@order) do |format|
        format.html { render :edit }
        format.js { render 'spree/checkout/update/failed' }
      end
    end
  end

  # don't redirect from /edit to separate states
  # we have them all in one place
  def skip_state_validation?
    true
  end

  def raise_insufficient_quantity
    flash[:error] = t(:spree_inventory_error_flash_for_insufficient_quantity)
    redirect_to main_app.dresses_path
  end

  def load_order
    @order = current_order
    redirect_to main_app.dresses_path and return unless @order and @order.checkout_allowed?
    raise_insufficient_quantity and return if @order.insufficient_stock_lines.present?
    redirect_to main_app.dresses_path and return if @order.completed?

    if params[:state]
      redirect_to checkout_state_path(@order.state) if @order.can_go_to_state?(params[:state]) && !skip_state_validation?
      @order.state = params[:state]
    end
    state_callback(:before)
  end

  # current_ability.authorize!(*args)
  # Spree::Ability.new(user).authorize!(:edit, order, token)
  def check_authorization
    authorize!(:edit, current_order, session[:access_token])
  end

  def edit
    unless signed_in?
      @user = Spree::User.new(
        email: @order.email,
        first_name: @order.user_first_name,
        last_name: @order.user_last_name
      )
    end

    respond_with(@order) do |format|
      format.js { render 'spree/checkout/update/success' }
      format.html{ render 'edit' }
      #format.html{ render 'markup_edit' }
    end
  end

  def before_address
    @order.bill_address ||= build_default_address
    @order.ship_address ||= build_default_address
  end

  private

  def object_params
    # For payment step, filter order parameters to produce the expected nested attributes for a single payment and its source, discarding attributes for payment methods other than the one selected
    if @order.has_checkout_step?("payment") && @order.payment?
      if params[:payment_source].present? && source_params = params.delete(:payment_source)[params[:order][:payments_attributes].first[:payment_method_id].underscore]
        params[:order][:payments_attributes].first[:source_attributes] = source_params
      end
      if (params[:order][:payments_attributes])
        params[:order][:payments_attributes].first[:amount] = @order.total
      end
    end
    params[:order].except(:password, :password_confirmation)
  end

  # run callback - preparations to order states
  def prepare_order
    before_address
  end

  def build_default_address
    address = Spree::Address.default(current_site_version)
    if (user = try_spree_current_user).present?
      address.firstname ||= user.first_name
      address.lastname ||= user.last_name
      address.email ||= user.email
    end

    if @order.present?
      address.firstname ||= @order.user_first_name
      address.lastname ||= @order.user_last_name
      address.email ||= @order.email
    end

    address
  end

  # after user submitted some shipping/biliing/payment data
  # order should not be in cart state
  def move_order_from_cart_state(order)
    if order.state == 'cart'
      order.next
      state_callback(:after)
    end
  end

  def find_payment_methods
    # @credit_card_gateway = CreditCardGatewayService.new(@order, current_site_version.currency, try_spree_current_user).gateway
    @credit_card_gateway = @order.available_payment_methods.detect{ |method| method.method_type.eql?('gateway') }
    @pay_pal_method = @order.available_payment_methods.detect do |method|
      method.method_type.eql?('paypalexpress') || method.type == 'Spree::Gateway::PayPalExpress'
    end
  end

  helper_method :completion_route

  def current_step
    return nil if @order.blank?
    return @current_step if @current_step.present?

    @current_step = @order.state.to_s
    @current_step = 'address' if @current_step.eql?('cart')
    @current_step
  end
  helper_method :current_step
end
