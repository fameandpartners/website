require 'uri'
require 'mastercard_masterpass_api'

module Spree
  class MasterpassController < StoreController
    include SslRequirement

    ssl_required :cart, :cartcallback, :confirm, :cancel

    before_filter :setup
    rescue_from RuntimeError, with: :set_error_message

    def cart
      # Get request token
      @request_token_response = @service.get_request_token(
          payment_method.request_url,
          payment_method.preferred_callback_domain)
      @data.request_token = @request_token_response.oauth_token

      # Post shopping cart
      items = current_order.line_items.map do |item|
        AllServicesMappingRegistry::ShoppingCartItem.new(
            item.variant.product.name + ' ' + item.variant.sku,
            item.quantity,
            (item.price * 100).round,
            Orders::LineItemPresenter.new(item, current_order).image.attachment.url)
      end

      tax_adjustments = current_order.adjustments.tax
      shipping_adjustments = current_order.adjustments.shipping

      subadjustments = 0
      current_order.adjustments.eligible.each do |adjustment|
        next if tax_adjustments.include?(adjustment)
        next if !payment_method.preferred_shipping_suppression && shipping_adjustments.include?(adjustment)

        subadjustments += adjustment.amount
        # items << AllServicesMappingRegistry::ShoppingCartItem.new(adjustment.label, 1, (adjustment.amount * 100).round)
      end
      if subadjustments != 0
        items << AllServicesMappingRegistry::ShoppingCartItem.new("Adjustments", 1, (subadjustments * 100).round)
      end

      items.each do |i|
        i.description = i.description[0..99] if i.description.length > 100
        i.description = i.description[0..98] if i.description.last == "&"
      end
      shopping_cart = AllServicesMappingRegistry::ShoppingCart.new(
          current_order.currency,
          (current_order.total * 100).round,
          items,
          nil)
      shopping_cart_request = AllServicesMappingRegistry::ShoppingCartRequest.new(
          @data.request_token,
          shopping_cart,
          payment_method.preferred_callback_domain)
      shopping_cart_response = AllServicesMappingRegistry::ShoppingCartResponse.from_xml(
          @service.post_shopping_cart_data(
              payment_method.shopping_cart_url,
              shopping_cart_request.to_xml_s)
      )
      save_session_data

      # flash[:commerce_tracking] = 'masterpass_initialized';
      render json: {
                 request_token: @data.request_token,
                 callback_domain: payment_method.preferred_callback_domain,
                 cart_callback_path: payment_method.preferred_callback_domain +
                     '/' + current_site_version.permalink +
                     '/masterpass/cartcallback?payment_method_id=' + params[:payment_method_id],
                 accepted_cards: payment_method.preferred_accepted_cards,
                 checkout_identifier: payment_method.preferred_checkout_identifier,
                 shipping_suppression: payment_method.preferred_shipping_suppression,
                 commerce_tracking: true
             }
    end

    def cartcallback
      # handle oauth callback
      @data.request_token = params['oauth_token']
      @data.verifier = params['oauth_verifier']
      @data.checkout_resource_url = params['checkout_resource_url']
      handle_pairing_callback if params['pairing_token'] && params['pairing_verifier']

      # get access token
      access_token_response = @service.get_access_token(
          payment_method.access_url,
          @data.request_token, @data.verifier)
      @data.access_token = access_token_response.oauth_token

      # get the checkout data
      checkout = AllServicesMappingRegistry::Checkout.from_xml(
          @service.get_payment_shipping_resource(
              @data.checkout_resource_url, @data.access_token
          ))

      if checkout.card && checkout.contact && checkout.shippingAddress
        # To resolve the error - "Singleton can't be dumped"
        @data.checkout = {
            :card => {
                :brandId => checkout.card.brandId,
                :brandName => checkout.card.brandName,
                :accountNumber => checkout.card.accountNumber,
                :cardHolderName => checkout.card.cardHolderName,
                :expiryMonth => checkout.card.expiryMonth,
                :expiryYear => checkout.card.expiryYear,
                :billingAddress => {
                    :city => checkout.card.billingAddress.city,
                    :country => checkout.card.billingAddress.country,
                    :countrySubdivision => checkout.card.billingAddress.countrySubdivision,
                    :line1 => checkout.card.billingAddress.line1,
                    :line2 => checkout.card.billingAddress.line2,
                    :postalCode => checkout.card.billingAddress.postalCode
                },
            },
            :contact => {
                :firstName => checkout.contact.firstName,
                :lastName => checkout.contact.lastName,
                :country => checkout.contact.country,
                :emailAddress => checkout.contact.emailAddress,
                :phoneNumber => checkout.contact.phoneNumber
            },
            :preCheckoutTransactionId => checkout.preCheckoutTransactionId,
            :transactionId => checkout.transactionId,
            :walletID => checkout.walletID,
            :shippingAddress => {
                :city => checkout.shippingAddress.city,
                :country => checkout.shippingAddress.country,
                :countrySubdivision => checkout.shippingAddress.countrySubdivision,
                :line1 => checkout.shippingAddress.line1,
                :line2 => checkout.shippingAddress.line2,
                :postalCode => checkout.shippingAddress.postalCode,
                :recipientName => checkout.shippingAddress.recipientName,
                :recipientPhoneNumber => checkout.shippingAddress.recipientPhoneNumber
            }
        }

        save_session_data

        redirect_to checkout_state_path('masterpass')
      else
        flash[:error] = t(:masterpass_processing_failed)

        redirect_to checkout_state_path('address')
      end
    end

    def cartpostback
      order = current_order || raise(ActiveRecord::RecordNotFound)
      if params[:mpstatus] == 'success'
        if current_order.confirmation_required?
          # TODO : Redirect to the confirmation page
          # redirect_to checkout_state_path(order.state)
        else
          confirm
          # render :complete
        end
      else
        flash[:error] = Spree.t('flash.generic_error', scope: 'masterpass', reasons: @data.checkout.errors.map(&:long_message).join(" "))
        redirect_to checkout_state_path(:payment)
      end
    end

    def confirm
      order = current_order
      order.payments.create!({
                                 :source => Spree::MasterpassCheckout.create({
                                                :access_token => @data.access_token,
                                                :transaction_id => @data.checkout.transactionId,
                                                :precheckout_transaction_id => @data.precheckout_transaction_id,
                                                :cardholder_name => @data.checkout.card.cardHolderName,
                                                :account_number => @data.checkout.card.accountNumber,
                                                :billing_address => @data.checkout.card.billingAddress.line1 + '<br/>' + @data.checkout.card.billingAddress.line2,
                                                :exp_date => @data.checkout.card.expiryMonth + '/' + @data.checkout.card.expiryYear,
                                                :brand_id => @data.checkout.card.brandId,
                                                :contact_name => @data.checkout.contact.firstName + ' ' + @data.checkout.contact.lastName,
                                                :gender => @data.checkout.contact.respond_to?(:gender) ? @data.checkout.contact.gender : nil,
                                                :birthday => @data.checkout.contact.respond_to?(:dateOfBirth) ? @data.checkout.contact.dateOfBirth.month + '/' +  @data.checkout.contact.dateOfBirth.day + '/' + @data.checkout.contact.dateOfBirth.year : nil,
                                                :national_id => @data.checkout.contact.respond_to?(:nationalID) ? @data.checkout.contact.nationalID : nil,
                                                :phone => @data.checkout.contact.phoneNumber,
                                                :email => @data.checkout.contact.emailAddress,
                                                :order_id => order.id
                                              }, :without_protection => true),
                                 :amount => order.total,
                                 :payment_method => payment_method
                             }, :without_protection => true)
      order.next
      if order.complete?
        flash.notice = Spree.t(:order_processed_successfully)
        flash[:commerce_tracking] = 'masterpass_ordered'
        session[:successfully_ordered] = true
        session[:masterpass_data] = nil

        flash[:order_completed] = true
        session[:order_id] = nil

        redirect_to order_path(order)
      else
        redirect_to checkout_state_path(order.state)
      end
    end

    def cancel
      flash[:notice] = Spree.t('flash.cancel', scope: 'masterpass')
      order = current_order || raise(ActiveRecord::RecordNotFound)
      session[:masterpass_data] = nil
      redirect_to checkout_state_path(order.state, masterpass_cancel_token: params[:token])
    end

    def payment_method
      Spree::PaymentMethod.find(params[:payment_method_id])
    end

    def provider
      payment_method.provider
    end

    def set_error_message(error)
      @data.error_message = error.to_s
      render
    end


    private

    def setup
      session[:masterpass_data] == nil ? @data = session[:masterpass_data] = MasterpassData.new : @data = session[:masterpass_data]
      @data.error_message = nil
      @service = Mastercard::Masterpass::MasterpassService.new(
          payment_method.preferred_consumer_key,
          OpenSSL::PKCS12.new(
              File.open(payment_method.keystore[:path]), payment_method.keystore[:password]
          ).key,
          payment_method.preferred_callback_domain,
          payment_method.server_mode)

      # create an unreferenced MasterpassDataMapper to include the mapping namespaces of our DTO's
      MasterpassDataMapper.new
    end

    def save_session_data
      session[:masterpass_data] = nil
      session[:masterpass_data] = @data
    end

    def handle_pairing_callback
      @data.pairing_token = params['pairing_token']
      @data.pairing_verifier = params['pairing_verifier']
      @data.long_access_token_response = @service.get_long_access_token(
          payment_method.access_token,
          @data.pairing_token,
          @data.pairing_verifier)

      # NOTE: we are storing the Long Access Token in a cookie for example purposes only. In a production environment this would be stored in the user's database record.
      @data.long_access_token = cookies["longAccessToken"] = @data.long_access_token_response.oauth_token
    end


  end
end
