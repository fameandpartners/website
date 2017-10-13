Spree::PaypalController.class_eval do
  include SslRequirement

  ssl_allowed

  before_filter :update_order_steps, only: [:confirm]

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
        :ReturnURL => confirm_paypal_url(:payment_method_id => params[:payment_method_id]),
        :CancelURL =>  cancel_paypal_url,
        :PaymentDetails => [payment_details(items)]
      }})

    current_order.return_type = params['return_type']
    current_order.save

    begin
      pp_response = provider.set_express_checkout(pp_request)
      if pp_response.success?
        redirect_to provider.express_checkout_url(pp_response)
      else
        flash[:error] = "PayPal failed. #{pp_response.errors.map(&:long_message).join(" ")}"
        redirect_to checkout_state_path(:payment)
      end
    rescue SocketError
      flash[:error] = "Could not connect to PayPal."
      redirect_to checkout_state_path(:payment)
    end
  end

  # update order step using info from paypal
  def update_order_steps
    order = current_order

    if !signed_in? # 'personal'
      update_order_personal_info
    end

    if !order.has_checkout_step?("address") || order.bill_address.blank? || order.shipping_address.blank?
      update_order_addresses
    end

    order.state = 'payment'
    order.save
  end

  protected

  def update_order_personal_info
    order = current_order

    user = order.user
    user ||= build_user(payment_details_response.get_express_checkout_details_response_details.payer_info)

    order.email           ||= prepare_email(user.email)
    order.user_first_name ||= user.first_name
    order.user_last_name  ||= user.last_name

    complete_order_step(order, 'cart')
  end

  # populate shipping/billing with paypal info, in case of 'cart checkout' / 'checkout from page'
  def update_order_addresses
    order = current_order
    if order.bill_address.blank? || order.shipping_address.blank?
      order.bill_address     ||= build_bill_address(payment_details_response)
      order.shipping_address ||= build_shipping_address(payment_details_response)

      complete_order_step(order, 'address')
    end
  end

  # state machine states have
  def complete_order_step(order, order_step)
    original_state = order.state
    order.state = order_step

    if !order.next
      order.state = original_state
      order.save(validate: false) # store data from paypal. user will be redirect to 'personal' tab
    end
  end


  private

  def build_bill_address(details)
    bill_address_details = details.get_express_checkout_details_response_details.payer_info.address
    payer_info = details.get_express_checkout_details_response_details.payer_info.payer_name
    parse_paypal_address(bill_address_details, payer_info)
  rescue
    Spree::Address.default
  end

  def build_shipping_address(details)
    ship_to_address_details = details.get_express_checkout_details_response_details.payment_details.first.ship_to_address
    payer_info = details.get_express_checkout_details_response_details.payer_info.payer_name
    parse_paypal_address(ship_to_address_details, payer_info)
  rescue
    Spree::Address.default
  end

  def parse_paypal_address(address_info, payer_details = nil)
    if address_info.address_status # == 'confirmed'?
      if payer_details
        firstname, lastname = payer_details.first_name, payer_details.last_name
      else
        firstname, lastname = address_info.name, address_info.name
      end
      Spree::Address.new(
        firstname: firstname,
        lastname: lastname,
        address1: address_info.street1,
        address2: address_info.street2,
        city:  address_info.city_name,
        zipcode: address_info.postal_code,
        country: Spree::Country.where(iso: address_info.country).first || Spree::Country.where(iso: 'AU').first,
        state_name: address_info.state_or_province,
        phone: address_info.phone || 'none'
      )
    end
  end

  def build_user(payer_info = nil)
    if payer_info.present?
      Spree::User.new(
        email: payer_info.payer,
        first_name: payer_info.payer_name.first_name,
        last_name: payer_info.payer_name.last_name,
        password: payer_info.payer_id,
        password_confirmation: payer_info.payer_id
      )
    else
      Spree::User.new()
    end
  end

  def payment_details_response
    @payment_details_response ||= begin
      details = provider.get_express_checkout_details(token: params[:token])
    end
  end

  def prepare_email(email)
    # user+subject@example.com => user@example.com
    # +part not working sometimes.
    email.to_s.sub(/\+.+@/, '@')
  end
end
