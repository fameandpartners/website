class ReturnMailer < ActionMailer::Base

  def notify_user(order_return_request)
    user_returns_object = create_formatted_order(order_return_request).as_json
    user = order_return_request.order.user
    Marketing::CustomerIOEventTracker.new.track(
      user,
      'return_started_email',
      user_data: user_returns_object
    )
  rescue StandardError => e
    Rails.logger.warn e
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

    def create_formatted_order(return_request)
      order = return_request.order
      user = order.user
      return_items = return_request.return_request_items
      billing_address = order.billing_address
      label_print_link = return_items.first.item_return&.item_return_label&.label_url
      #todo: need to revisit this next line when we get final delivery date approval
      send_by_date = (return_items.map {|rri| rri.line_item.delivery_period_policy.delivery_date }.max + 45.days).strftime("%m/%d/%y")
      international_user = order.shipping_address&.country_id != 49
      
      formatted_return_items = return_items.map do |item|
        {
          name: item.line_item&.style_name,
          size: item.line_item&.size&.presentation,
          color: item.line_item&.color&.presentation,
          image: item.line_item&.image_url,
          price: item.line_item&.price,
          height_copy: convert_height_units(item.line_item&.personalization&.height_value, item.line_item&.personalization&.height_unit)
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
          "address_one": billing_address&.address1,
          "address_two": billing_address&.address2,
          "city": billing_address&.city,
          "state": billing_address&.state&.abbr,
          "zipcode": billing_address&.zipcode
        },
        "items": formatted_return_items,
        "international_user": international_user
      }
    end
end
