require 'uri'
require 'mastercard_masterpass_api'

module Spree
  class MasterpassController < StoreController
    include SslRequirement
    include CheckoutHelper

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
                 cart_callback_path: payment_method.preferred_callback_domain + '/masterpass/cartcallback?payment_method_id=' + params[:payment_method_id],
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
      @data.checkout = AllServicesMappingRegistry::Checkout.from_xml(
          @service.get_payment_shipping_resource(
              @data.checkout_resource_url, @data.access_token
          ));

      # edit() from checkout_controller_decorator (address step)
      unless signed_in?
        @user = Spree::User.new(
            email: current_order.email,
            first_name: current_order.user_first_name,
            last_name: current_order.user_last_name
        )
      end

      # update first/last names, email,...
      # Need to get country_id, state_id, ship_address validation
      billing_country = available_countries_for_current_zone.any?{|country| country.name == @data.checkout.card.billingAddress.country}
      billing_country_id = !billing_country.nil? ? billing_country.id : ''
      billing_state = available_states_for_current_zone.any?{|state| state.name == @data.checkout.card.billingAddress.countrySubdivision}
      billing_state_id = !billing_state.nil? ? billing_state.id : ''

      shipping_country = available_countries_for_current_zone.any?{|country| country.name == @data.checkout.card.shippingAddress.country}
      shipping_country_id = !shipping_country.nil? ? shipping_country.id : ''
      shipping_state = available_states_for_current_zone.any?{|state| state.name == @data.checkout.card.shippingAddress.countrySubdivision}
      shipping_state_id = !shipping_state.nil? ? shipping_state.id : ''

      object_params = {
          :order => {
            :bill_address_attributes => {
                :email => @data.checkout.contact.emailAddress,
                :firstname => @data.checkout.contact.firstName,
                :lastname => @data.checkout.contact.lastName,
                :address1 => @data.checkout.card.billingAddress.line1,
                :address2 => @data.checkout.card.billingAddress.line2,
                :city => @data.checkout.card.billingAddress.city,
                :state_id => billing_state_id,
                :country_id => billing_country_id,
                :phone => @data.checkout.contact.phoneNumber,
                :zipcode => @data.checkout.card.billingAddress.postalCode
            },
            :ship_address_attributes => {
                :firstname => @data.checkout.shippingAddress.recipientName,
                :lastname => @data.checkout.shippingAddress.recipientName,
                :address1 => @data.checkout.shippingAddress.line1,
                :address2 => @data.checkout.shippingAddress.line2,
                :city => @data.checkout.shippingAddress.city,
                :state_id => shipping_state_id,
                :country_id => shipping_country_id,
                :phone => @data.checkout.shippingAddress.recipientPhoneNumber,
                :zipcode => @data.checkout.shippingAddress.postalCode
            }
          }
        }
      registration = Services::UpdateUserRegistrationForOrder.new(current_order, try_spree_current_user, object_params)
      registration.update
      if registration.new_user_created?
        fire_event("spree.user.signup", order: current_order)
        sign_in :spree_user, registration.user
      end
      if !registration.successfull?
        # respond_with(current_order) do |format|
        #   format.html { redirect_to checkout_state_path(current_order.state) }
        # end
        return
      end

      if current_order.update_attributes(object_params[:order])
        fire_event('spree.checkout.update')

        if current_order.next
          state_callback(:after)
        else
          flash[:error] = t(:payment_processing_failed)
          respond_with(current_order) do |format|
            format.html{ redirect_to checkout_state_path(current_order.state) }
            format.js{ render 'spree/checkout/update/failed' }
          end
          return
        end

        respond_with(current_order) do |format|
          format.html{ redirect_to checkout_state_path(@order.state) }
          format.js{ render 'spree/checkout/update/success' }
        end
      else
        respond_with(current_order) do |format|
          format.html { render 'spree/checkout/edit' }
          format.js { render 'spree/checkout/update/failed' }
        end
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
