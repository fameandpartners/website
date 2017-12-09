module Guest
  class PaypalController < Spree::PaypalController
    include GuestHelper
    include SslRequirement

    ssl_allowed

    prepend_before_filter :check_presence_of_token
    skip_before_filter :check_cart

    def express
      items = current_order.line_items.map do |item|
        {
          :Name => item.product.name,
          :Quantity => item.quantity,
          :Amount => {
            :currencyID => current_order.currency,
            :value => item.price
          },
          :ItemCategory => "Physical"
        }
      end

      tax_adjustments = current_order.adjustments.tax
      shipping_adjustments = current_order.adjustments.shipping

      current_order.adjustments.eligible.each do |adjustment|
        next if (tax_adjustments + shipping_adjustments).include?(adjustment)
        items << {
          :Name => adjustment.label,
          :Quantity => 1,
          :Amount => {
            :currencyID => current_order.currency,
            :value => adjustment.amount
          }
        }
      end

      # Because PayPal doesn't accept $0 items at all.
      # See #10
      # https://cms.paypal.com/uk/cgi-bin/?cmd=_render-content&content_ID=developer/e_howto_api_ECCustomizing
      # "It can be a positive or negative value but not zero."
      items.reject! do |item|
        item[:Amount][:value].zero?
      end

      pp_request = provider.build_set_express_checkout({
                                                         :SetExpressCheckoutRequestDetails => {
                                                           :ReturnURL => main_app.guest_confirm_paypal_url(:payment_method_id => params[:payment_method_id]),
                                                           :CancelURL => main_app.guest_cancel_paypal_url,
                                                           :PaymentDetails => [payment_details(items)]
                                                         }})

      begin
        pp_response = provider.set_express_checkout(pp_request)
        if pp_response.success?
          redirect_to provider.express_checkout_url(pp_response)
        else
          flash[:error] = "PayPal failed. #{pp_response.errors.map(&:long_message).join(" ")}"
          redirect_to main_app.guest_checkout_state_path(:payment)
        end
      rescue SocketError
        flash[:error] = "Could not connect to PayPal."
        redirect_to main_app.guest_checkout_state_path(:payment)
      end
    end

    def confirm
      order = current_order
      order.payments.create!({
                               :source => Spree::PaypalExpressCheckout.create({
                                                                                :token => params[:token],
                                                                                :payer_id => params[:PayerID]
                                                                              }, :without_protection => true),
                               :amount => order.total,
                               :payment_method => payment_method
                             }, :without_protection => true)
      order.next
      if order.complete?
        OrderBotWorker.perform_async(order.id)
        flash.notice = Spree.t(:order_processed_successfully)
        flash[:commerce_tracking] = 'nothing special'
        session[:successfully_ordered] = true

        redirect_to main_app.guest_checkout_thanks_path
      else
        redirect_to main_app.guest_checkout_state_path(order.state)
      end
    end

    def cancel
      flash[:notice] = "Don't want to use PayPal? No problems."
      redirect_to main_app.guest_checkout_state_path(current_order.state)
    end

    private

    def current_order
      return @order if @order.present?

      raise ActiveRecord::RecordNotFound unless session['guest_checkout_token'].present?

      @payment_request = PaymentRequest.find_by_token!(session['guest_checkout_token'])

      order = Spree::Order.find(@payment_request.order_id)

      if order.complete?
        raise ActiveRecord::RecordNotFound
      else
        @order = order
      end
    end
  end
end
