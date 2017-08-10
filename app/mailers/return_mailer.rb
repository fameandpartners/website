class ReturnMailer < ActionMailer::Base

  def create_formatted_order(return_request)
    order = return_request.order
    user = order.user
    return_items = return_request.return_request_items
    billing_address = order.billing_address
    label_print_link = return_items.first.item_return.return_label[:label_url]
    send_by_date = (return_request.order.projected_delivery_date + 45).strftime("%m/%d/%y")
    formatted_return_items = return_items.map do |item|
      {
        name: item.line_item&.product&.name,
        size: item.line_item&.cart_item&.size&.presentation,
        color: item.line_item&.cart_item&.color&.presentation,
        image: item.line_item&.cart_item&.image&.large,
        price: item.line_item&.product&.price,
        height_value: item.line_item&.personalization&.height_value,
        height_unit: item.line_item&.personalization&.height_unit
      }
    end

    # .sum isn't working for some reason (also need to verify this includes tax / discounts...)
    total_refund_amount = formatted_return_items.reduce(0) { |sum, item| sum + item[:price] }

    {
      "order_number": order.number,
      "email": user.email,
      "send_by_date": send_by_date,
      "label_url": label_print_link,
      "total_refund": total_refund_amount,
      "address": {
        "address_one": billing_address[:address1],
        "address_two": billing_address[:address2],
        "city": billing_address[:city],
        "state": billing_address.state[:abbr],
        "zipcode": billing_address[:zipcode]
      },
      "items": formatted_return_items
    }
  end

  def notify_user(order_return_request)
    user_returns_object = create_formatted_order(order_return_request).as_json
    user = order_return_request.order.user
    Marketing::CustomerIOEventTracker.new.track(
      user,
      'return_started_email',
      userData: user_returns_object
    )
  rescue StandardError => e
    NewRelic::Agent.notice_error(e)
    Raven.capture_exception(e)
  end
end
