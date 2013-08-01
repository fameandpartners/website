Spree::CheckoutController.class_eval do
  before_filter :prepare_order, only: :edit
  skip_before_filter :check_registration

  def update_registration
    fire_event("spree.user.signup", :order => current_order)
    
    if params[:create_account]
      @user = Spree::User.new(params[:user])
      if @user.save
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
        @user.errors.messages.keys.each{|field| @user.errors.delete(field) if field.to_sym != :email}
        render 'spree/checkout/registration/failed'
      end
    end
  end

  def update
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
      @user = Spree::User.new
      @user.email ||= @order.email
    end

    respond_with(@order) do |format|
      format.js { render 'spree/checkout/update/success' }
      format.html{ render }
    end
  end

  private

  # run callback - preparations to order states
  def prepare_order
    before_address
  end

  helper_method :completion_route
end
