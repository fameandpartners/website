Spree::CheckoutController.class_eval do
  before_filter :prepare_order, only: :edit
  before_filter :find_payment_methods, only: [:edit, :update]
  skip_before_filter :check_registration

  def update_registration
    fire_event("spree.user.signup", :order => current_order)
    
    if params[:create_account]
      @user = Spree::User.new(params[:user])
      if @user.save
        sign_in :spree_user, @user

        # hack - temporarily change the state to something other than cart so we can validate the order email address
        current_order.state = current_order.checkout_steps.first

        current_order.user = @user
        current_order.email = @user.email
        current_order.user_first_name = @user.first_name
        current_order.user_last_name = @user.last_name
        current_order.save

        before_address

        render 'spree/checkout/registration/success'
      else
        render 'spree/checkout/registration/failed'
      end
    else
      @order = current_order
      @user = Spree::User.new(params[:user])
      @user.valid?

      if @user.errors
        @user.errors.delete(:password)
        @user.errors.delete(:password_confirmation)
      end

      if @user.errors.blank?
        @order.email = @user.email
        @order.user_first_name = @user.first_name
        @order.user_last_name = @user.last_name
        @order.state = current_order.checkout_steps.first
        @order.save

        @order.errors.clear
        @order.user = @user

        before_address

        render 'spree/checkout/registration/success'
      else
        render 'spree/checkout/registration/failed'
      end
    end
  end

  # update - address/payment
  def update
    move_order_from_cart_state(@order)

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
    @credit_card_gateway = @order.available_payment_methods.detect{ |method| method.method_type.eql?('gateway') }
    @pay_pal_method = @order.available_payment_methods.detect{ |method| method.method_type.eql?('paypalexpress') }
  end

  helper_method :completion_route
end
