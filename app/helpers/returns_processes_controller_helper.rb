module ReturnsProcessesControllerHelper

  ERROR_MESSAGES = {
    :RETRY => "Please try again.",
    :CONTACT => "Something's wrong, please contact customer service.",
    :RETURN_EXISTS => "These items already have a return.",
    :NO_ITEMS_SELECTED => "Please select an item you would like to return.",
    :INCORRECT_GUEST_PARAMS => "Incorrect parameters. Expecting { email: STRING, order_number: STRING }.",
    :GUEST_ORDER_NOT_FOUND => "No order found."
  }

  ERROR_CODES = {
    :INCORRECT_GUEST_PARAMS => 10,
    :GUEST_ORDER_NOT_FOUND => 20,
    :USER_NOT_FOUND => 30,
    :INCORRECT_PARAMS => 40,
    :INVALID_ORDER_ID => 50,
    :INCORRECT_ORDER_ID => 60,
    :NON_EXISTENT_LINE_ITEMS => 70,
    :INCORRECT_LINE_ITEMS => 80,
    :RETURN_EXISTS => 90,
    :LABEL_FAILED => 100
  }

  def has_incorrect_guest_params?
    !(params['email'].present? && params['order_number'].present?)
  end

  def has_incorrect_params?
    !(params['order_number'].present? && params['line_items'].present?)
  end

  def has_invalid_order_number?(number)
    !Spree::Order.completed.exists?(:number=>number)
  end

  def has_incorrect_order_number?(number)
    order = Spree::Order.completed.find_by_number(number)
    email = params['email'] || spree_current_user.email

    order.email != email && order.user.email != email
  end

  def has_nonexistent_line_items?(arr)
    arr.any? do |id|
      !Spree::LineItem.exists?(id)
    end
  end

  def has_incorrect_line_items?(arr, order_number)
    arr.any? do |id|
      Spree::LineItem.where(id: id).first&.order.number != order_number
    end
  end

  def has_existing_returns?(arr)
    arr.any? do |id|
      ItemReturn.exists?(line_item_id: id)
    end
  end

  def has_us_shipping_address?(order_number)
    Spree::Order.find_by_number(order_number).shipping_address&.country_id == 49
  end

  def process_returns(obj, return_label)
		order = Spree::Order.find_by_number(obj[:order_number])

		if order.nil?
			return
		end

    return_request = {
      :order_return_request => {
        :order_id => order.id,
        :return_request_items_attributes => obj[:line_items]
      }
    }
    puts "OrderReturnRequest.new"
    @order_return = OrderReturnRequest.new(return_request[:order_return_request])

    @order_return.save

    if (has_us_shipping_address?(order.number))
      return_label.save
      @order_return.return_request_items.each do |x|
        x.item_return.item_return_label = return_label
        x.item_return.save!
      end

      @order_return.save
    end

    start_bergen_return_process(@order_return)
    start_next_logistics_process(@order_return)
		success_response(@order_return.id)

    return
  end


  def self.create_label(order_number)
    order = Spree::Order.find_by_number(order_number)

    label = Newgistics::ShippingLabel.new(
      order.user_first_name,
      order.user_last_name,
      order.shipping_address,
      order.email,
      order.number
    )

    if(label.fetch_shipping_label_from_api.nil?)
      return nil
    end
    item_return_label = ItemReturnLabel.new(
      :label_image_url => label.label_image_url,
      :label_pdf_url => label.label_pdf_url,
      :label_url => label.label_url,
      :carrier => label.carrier,
      :barcode => label.barcode
      )
  end

  def error_response(err, *err_code)
    message = ERROR_MESSAGES[err]

    if err_code.present?
      error_code = ERROR_CODES[err_code.first]
    else
      error_code = ERROR_CODES[err]
    end

    payload = {
      error: message,
      error_code: error_code,
      status: 400
    }

    Raven.capture_exception(payload.to_json)

    respond_with err do |format|
      format.json do
        render :json => payload, :status => :bad_request
      end
    end
  end

  def success_response(request_id)
    payload = {
			request_id: request_id,
      status: 200
    }
    respond_with request_id do |format|
      format.json do
        render :json => payload, :status => :ok
      end
    end
  end

  def start_bergen_return_process(order_return)
    order_return.return_request_items.each do |rri|
      Bergen::Operations::ReturnItemProcess.new(return_request_item: rri).start_process
    end

    ReturnMailer.notify_user(order_return).deliver
  end

  def start_next_logistics_process(order_return)
    if Features.active?(:next_logistics)
      NextLogistics::ReturnRequestProcess.new(order_return_request: order_return).start_process
    end
  end

end
