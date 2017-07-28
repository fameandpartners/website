module Guest
  class CheckoutController < Spree::CheckoutController
    include GuestHelper
    include StripeHelper
    prepend_before_filter :check_presence_of_token
    prepend_before_filter :save_token_to_session, only: [:edit]

    skip_before_filter :ensure_valid_state
    skip_before_filter :associate_user
    skip_before_filter :check_authorization
    skip_before_filter :check_registration

    include SslRequirement
    ssl_required :edit, :update

    layout 'guest'

    def edit
      respond_with(@order) do |format|
        format.js { render 'guest/checkout/update/success' }
        format.html{ @order.complete? ? render('complete') : render }
      end
    end

    def update
      move_order_from_cart_state(@order)

      if @order.update_attributes(object_params)
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

        unless @order.next
          flash[:error] = t(:payment_processing_failed)
          respond_with(@order) do |format|
            format.html{ redirect_to checkout_state_path(@order.state) }
            format.js{ render 'guest/checkout/update/failed' }
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
            format.js{ render 'guest/checkout/complete' }
          end
        else
          respond_with(@order) do |format|
            format.html{ redirect_to checkout_state_path(@order.state) }
            format.js{ render 'guest/checkout/update/success' }
          end
        end
      else
        respond_with(@order) do |format|
          format.html { render :edit }
          format.js { render 'guest/checkout/update/failed' }
        end
      end
    end

    private

    def load_order
      @payment_request ||= PaymentRequest.find_by_token!(session['guest_checkout_token'])

      @order = Spree::Order.find(@payment_request.order_id)
      if params[:action].eql?('update') && @order.complete?
        raise ActiveRecord::RecordNotFound
      end

      if params[:state]
        redirect_to guest_checkout_state_path(@order.state) if @order.can_go_to_state?(params[:state]) && !skip_state_validation?
        @order.state = params[:state]
      end
      state_callback(:before)
    end

    def before_address
      @order.bill_address ||= Spree::Address.default
      @order.ship_address ||= Spree::Address.default
    end
  end
end
