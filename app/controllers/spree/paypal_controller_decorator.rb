Spree::PaypalController.class_eval do
  before_filter :autofill_address_if_needed, only: [:confirm]

  # populate shipping/billing with paypal info, in case of 'cart checkout' / 'checkout from page'
  def autofill_address_if_needed
    order = current_order
    if order.bill_address.blank? || order.shipping_address.blank?
      order.bill_address     ||= build_bill_address(payment_details_response)
      order.shipping_address ||= build_shipping_address(payment_details_response)
      if order.valid?
        order.state = 'address'
        order.save
        order.next
      else
        order.save(validate: false) # store data from paypal and redirect to 'address' state
      end
    end
  end

  def build_bill_address(details)
    bill_address = details.get_express_checkout_details_response_details.payer_info.address
    parse_paypal_address(bill_address)
  rescue
    Spree::Address.default
  end

  def build_shipping_address(details)
    ship_to_address = details.get_express_checkout_details_response_details.payment_details.first.ship_to_address
    parse_paypal_address(ship_to_address)
  rescue
    Spree::Address.default
  end

  def parse_paypal_address(info)
    if info.address_status # == 'confirmed'?
      Spree::Address.new(
        firstname: info.name,
        lastname: info.name,
        address1: info.street1,
        address2: info.street2,
        city:  info.city_name,
        zipcode: info.postal_code,
        country: Spree::Country.where(iso: info.country).first || Spree::Country.where(iso: 'AU').first,
        state_name: info.state_or_province,
        phone: info.phone || 'none'
      )
    end
  end

  def payment_details_response
    @payment_details_response ||= begin
      details = provider.get_express_checkout_details(token: params[:token])
    end
  end
end
