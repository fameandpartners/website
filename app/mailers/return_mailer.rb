class ReturnMailer < ActionMailer::Base

  def create_formatted_order(return_request)
    order = return_request.order
    user = order.user
    return_items = return_request.return_request_items
    billing_address = order.billing_address
    label_print_link = return_items.first.item_return.return_label[:label_url]

    formatted_return_items = return_items.map do |item|
      {
        name: item.line_item&.product&.name,
        size: item.line_item&.cart_item&.size&.presentation,
        color: item.line_item&.cart_item&.color&.presentation,
        image: item.line_item&.cart_item&.image&.large,
        price: item.line_item&.product&.price
      }
    end

    # .sum isn't working for some reason (also need to verify this includes tax / discounts...)
    total_refund_amount = formatted_return_items.reduce(0) { |sum, item| sum + item[:price] }

    {
      "order_number": order.number,
      "user": user,
      "email": user.email,
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

    Marketing::CustomerIOEventTracker.new.track(
      user,
      'return_started_email',
      email_to: user_returns_object['email'],
      subject: "Refund notification for Order #" + user_returns_object['order_number'],
      order_number: user_returns_object['order_number'],
      amount: user_returns_object['total_refund'],
    )
  rescue StandardError => e
    NewRelic::Agent.notice_error(e)
    Raven.capture_exception(e)
  end
end
