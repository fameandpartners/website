require 'uri'
include REXML

module Spree
  class MasterpassController < StoreController

    before_filter :setup
    after_filter :save_session_data
    rescue_from RuntimeError, with: :set_error_message

    def cart
      # Get request token
      @request_token_response = @service.get_request_token(
          payment_method.request_url,
          payment_method.callback_domain)
      @data.request_token = @request_token_response.oauth_token

      # Post shopping cart
      items = current_order.line_items.map do |item|
        AllServicesMappingRegistry::ShoppingCartItem.new(
            item.product.name + ' ' + item.variant.sku,
            item.quantity,
            (item.price * 100).to_i,
            item.image.mini_url)
      end

      tax_adjustments = current_order.adjustments.tax
      shipping_adjustments = current_order.adjustments.shipping

      current_order.adjustments.eligible.each do |adjustment|
        next if tax_adjustments.include?(adjustment) || shipping_adjustments.include?(adjustment)

        items << AllServicesMappingRegistry::ShoppingCartItem.new(adjustment.label, 1, adjustment.amount)
      end
      items.each do |i|
        i.description = i.description[0..99] if i.description.length > 100
        i.description = i.description[0..98] if i.description.last == "&"
      end
      shopping_cart = AllServicesMappingRegistry::ShoppingCart.new(
          current_order.currency,
          (current_order.total * 100).to_i,
          items,
          nil)
      shopping_cart_request = AllServicesMappingRegistry::ShoppingCartRequest.new(
          @data.request_token,
          shopping_cart,
          payment_method.callback_domain)
      shopping_cart_response = AllServicesMappingRegistry::ShoppingCartResponse.from_xml(
          @service.post_shopping_cart_data(
              payment_method.shopping_cart_url,
              shopping_cart_request.to_xml_s)
      )

      # file = File.read(File.join('spree_masterpass', 'resources', 'shoppingCart.xml'))
      # shopping_cart_request = AllServicesMappingRegistry::ShoppingCartRequest.from_xml(file)
      # shopping_cart_request.oAuthToken = @data.request_token
        # shopping_cart_request.originUrl = provider.callback_domain

      render json: {
                 request_token: @data.request_token,
                 callback_domain: provider.callback_domain,
                 cart_callback_path: provider.callback_domain + '/masterpass/cartcallback?payment_method_id=' + params[:payment_method_id],
                 accepted_cards: payment_method.preferred_accepted_cards,
                 checkout_identifier: payment_method.preferred_checkout_identifier,
                 shipping_suppression: payment_method.preferred_shipping_suppression
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
      @data.checkout = AllServicesMappingRegistry::Checkout.from_xml(
          @service.get_payment_shipping_resource(
              @data.checkout_resource_url, @data.access_token
          ));

      order = current_order || raise(ActiveRecord::RecordNotFound)
      if @data.params[:mpstatus] == 'success'
        if current_order.confirmation_required?
          # TODO : Redirect to the confirmation page
          # redirect_to checkout_state_path(order.state)
        else
          log_transaction
          confirm
          # render :complete
        end
      else
        flash[:error] = Spree.t('flash.generic_error', scope: 'masterpass', reasons: @data.checkout.errors.map(&:long_message).join(" "))
        redirect_to checkout_state_path(:payment)
      end
    end

    def confirm
      order = current_order || raise(ActiveRecord::RecordNotFound)
      order.payments.create!({
                                 source: Spree::MasterPassCheckout.create({
                                                                              token: @data.access_token,
                                                                              transaction_id: @data.checkout.transactionId,
                                                                          }),
                                 amount: order.total,
                                 payment_method: payment_method
                             })
      order.next
      if order.complete?
        flash.notice = Spree.t(:order_processed_successfully)
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
      session['masterpass_data'] == nil ? @data = session['masterpass_data'] = MasterpassData.new : @data = session['masterpass_data']
      @data.error_message = nil
      @service = Mastercard::Masterpass::MasterpassService.new(
          payment_method.preferred_consumer_key,
          OpenSSL::PKCS12.new(
              File.open(payment_method.keystore[:path]), payment_method.keystore[:password]
          ).key,
          payment_method.callback_domain,
          Mastercard::Common::SANDBOX)

      # create an unreferenced MasterpassDataMapper to include the mapping namespaces of our DTO's
      MasterpassDataMapper.new
    end

    def save_session_data
      session['masterpass_data'] = nil
      session['masterpass_data'] = @data
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



    def log_transaction
      approval_code = "sample"
      if (!approval_code)
        approval_code = "UNAVBL"
      end
      merchant_transactions = AllServicesMappingRegistry::MerchantTransactions.new
      merchant_transaction = AllServicesMappingRegistry::MerchantTransaction.new(
          @data.checkout.transactionId,
          payment_method.consumer_key,
          item.order.currency,
          (current_order.total * 100).to_i,
          Time.now,
          "Success",
          approval_code,
          @data.precheckout_transaction_id)
      merchant_transactions << merchant_transaction
      xml = merchant_transactions.to_xml
      # we need to pluralize the child MerchantTransaction node name to adhere to the XML schema
      XPath.first(xml, "//MerchantTransaction").name = "MerchantTransactions"
      @data.post_transaction_sent_xml = xml.to_s
      response_xml = ""
      Document.new(service.post_checkout_transaction(payment_method.postback_url, xml), {:compress_whitespace => :all}).write(response_xml, 2)

      # and change the child MerchantTransaction node name back to singular for proper xml mapping if we want to get a Ruby object back from the xml
    end
  end
end