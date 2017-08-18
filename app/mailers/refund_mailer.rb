class RefundMailer < ActionMailer::Base

  def notify_user(event)
    line_item = event.item_return.line_item
    order = line_item.order
    user = order.user
    subject = "Refund notification for order #{order.number}"
    userData = Spree::Order.where(email: event.user).first
    address_object = Spree::Address.where(id: userData.bill_address_id).first
    product_data = {
      name: line_item&.product&.name,
      size: line_item&.cart_item&.size&.presentation,
      color: line_item&.cart_item&.color&.presentation,
      image: line_item&.cart_item&.image&.large,
      price: line_item&.price,
      height_copy: convert_height_units(line_item&.personalization&.height_value, line_item&.personalization&.height_unit)
    }
    user_returns_object = {
      "order_number": event.item_return.order_number,
      "first_name": userData.first_name,
      "last_name": userData.last_name,
      "email": userData.email,
      "total_refund": event.refund_amount,
      "address": {
        "address_one": address_object.address1,
        "address_two": address_object.address2,
        "city": address_object.city,
        "state": address_object.state.abbr,
        "zipcode": address_object.zipcode
      },
      "item": product_data,
    }
    Marketing::CustomerIOEventTracker.new.track(
      user,
      'refund_notification_email',
      email_to:                    userData.email,
      user_data:                   user_returns_object
    )
  rescue StandardError => e
    NewRelic::Agent.notice_error(e)
    Raven.capture_exception(e)
  end

  private
    def convert_height_units(height_value, height_unit)
      if ( !height_value || !height_unit)
        return nil
      end
      if (height_unit == 'inch')
        "#{height_value.to_i / 12}ft #{height_value.to_i % 12}in"
      else
        "#{height_value}cm"
      end
    end
end
