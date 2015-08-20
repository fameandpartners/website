require 'all_services/all_services'

module Spree
  class MasterpassController < StoreController

    before_filter :setup
    after_filter :save_session_data
    rescue_from RuntimeError, with: :set_error_message

    def cart
      # Get request token
      @request_token_response = payment_method.get_request_token
      @data.request_token = @request_token_response.oauth_token

      # Post shopping cart
      # items = current_order.line_items.map do |item|
      #   ShoppingCartItem.new(item.product.name + ' ' + item.variant.sku, item.quantity, (item.price * 100).to_i, item.image.mini_url)
      # end
      #
      # tax_adjustments = current_order.adjustments.tax
      # shipping_adjustments = current_order.adjustments.shipping
      #
      # current_order.adjustments.eligible.each do |adjustment|
      #   next if tax_adjustments.include?(adjustment) || shipping_adjustments.include?(adjustment)
      #
      #   items << ShoppingCartItem.new(adjustment.label, 1, adjustment.amount)
      # end
      # items.each do |i|
      #   i.description = i.description[0..99] if i.description.length > 100
      #   i.description = i.description[0..98] if i.description.last == "&"
      # end
      # shopping_cart = ShoppingCart.new((current_order.total * 100).to_i.to_s, current_order.currency, nil, items)
      # shopping_cart_request = ShoppingCartRequest.new(@data.request_token, shopping_cart, provider.callback_domain)
      file = File.read(File.join('spree_masterpass', 'resources', 'shoppingCart.xml'))
      shopping_cart_request = ShoppingCartRequest.from_xml(file)
      shopping_cart_request.oAuthToken = @data.request_token
      shopping_cart_request.originUrl = provider.callback_domain

      @shopping_cart_response = ShoppingCartResponse.from_xml(payment_method.get_shopping_cart_response(shopping_cart_request))

      render json: {
                 request_token: @data.request_token,
                 callback_domain: provider.callback_domain,
                 cart_callback_path: provider.callback_domain + '/cartcallback',
                 accepted_cards: payment_method.preferred_accepted_cards,
                 checkout_identifier: payment_method.preferred_checkout_identifier,
                 shipping_suppression: payment_method.preferred_shipping_suppression
             }
    end

    def cartcallback
      handle_oauth_callback
      get_access_token
      get_checkout_data
      render :cart
    end

    def confirm

    end

    def refund

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

      # create an unreferenced MasterpassDataMapper to include the mapping namespaces of our DTO's
      MasterpassDataMapper.new
    end

    def save_session_data
      session['masterpass_data'] = nil
      session['masterpass_data'] = @data
    end
  end
end