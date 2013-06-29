Spree::CheckoutController.class_eval do
  before_filter :prepare_order, only: :edit
  skip_before_filter :check_registration

  def update_registration
    fire_event("spree.user.signup", :order => current_order)

    @user = Spree::User.new(params[:user])
    if @user.save
      # hack - temporarily change the state to something other than cart so we can validate the order email address
      current_order.state = current_order.checkout_steps.first

      current_order.user = @user
      current_order.email = @user.email
      current_order.save

      before_address

      render 'spree/checkout/registration/success'
    else
      render 'spree/checkout/registration/failed'
    end
  end

  def update
    if @order.update_attributes(object_params)

      fire_event('spree.checkout.update')
      unless apply_coupon_code
        respond_with(@order) { |format| format.html { render :edit } }
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
    @user = Spree::User.new unless signed_in?
  end

  private

  # run callback - preparations to order states
  def prepare_order
    before_address
  end

  helper_method :completion_route
end
