class RefundService
  def initialize(item_return_id:, refund_data:)
    @item_return_id = item_return_id
    @refund_data = refund_data
  end

  def process
    # manually fill in payment method
    if Spree::Gateway::QuadpayPayment.payment_method and (gateway.id == Spree::Gateway::QuadpayPayment.payment_method.id)
      @refund_data["refund_method"] = "QuadpayPayment"
    else
      @refund_data["refund_method"] = @gateway.type.split('::').last
    end

    if refund_event.valid?
      response = send_refund_request
      if response_success?(response)#response.success?
        refund_event.save!
        process_save_status(response)

        { status: :success, event: refund_event }
      else
        { status: :error, message: response_message(response) }
      end
    else
      { status: :error, message: refund_event.errors.full_messages.join("\n") }
    end
  rescue StandardError => e
    { status: :error, message: e.message }
  end

  private
  def response_success?(response)
    if gateway.type == "Spree::Gateway::Pin"
      response.success?
    elsif gateway.type == "Spree::Gateway::FameStripe"
      response[:status] == "succeeded"
    elsif gateway.type == "Spree::Gateway::PayPalExpress"
      response.success?
    elsif Spree::Gateway::QuadpayPayment.payment_method and (gateway.id == Spree::Gateway::QuadpayPayment.payment_method.id)
      response.success?
    end
  end

  def process_save_status(response)
    item_return.refund_status = 'Complete'

    if gateway.id == Spree::Gateway::QuadpayPayment.payment_method.id
      item_return.refund_method = "QuadpayPayment"
    else
      item_return.refund_method = @gateway.type.split('::').last
    end

    item_return.refund_amount = Money.parse(refund_amount).amount

    if gateway.type == "Spree::Gateway::Pin"
      item_return.refund_ref    = response.params['response']['token']
      item_return.refunded_at   = Time.parse(response.params['response']['created_at'])
    elsif gateway.type == "Spree::Gateway::FameStripe"
      item_return.refund_ref    = response[:id]
      item_return.refunded_at   = Time.now
    elsif gateway.type == "Spree::Gateway::PayPalExpress"
      item_return.refund_ref    = response.RefundTransactionID
      item_return.refunded_at   = Time.now
    elsif Spree::Gateway::QuadpayPayment.payment_method and (gateway.id == Spree::Gateway::QuadpayPayment.payment_method.id)
      item_return.refund_ref    = response.params['qp_order_id']
      item_return.refunded_at   = Time.now
    end

    item_return.save!
  end

  def response_message(response)
    if response.params['messages'].present?
      response.params['messages'].map { |m| m['message'] }.join("\n")
    else
      response.message
    end
  end

  def send_refund_request
    if gateway.type == "Spree::Gateway::PayPalExpress"
      gateway.refund_reparam(@refund_data['refund_amount'], item_return)
    elsif Spree::Gateway::QuadpayPayment.payment_method and (gateway.id == Spree::Gateway::QuadpayPayment.payment_method.id)
      gateway.refund_reparam(@refund_data['refund_amount'], item_return)
    else
      gateway.refund(refund_amount, item_return.order_payment_ref)
    end
  end

  def refund_amount
    (@refund_data['refund_amount'].to_f * 100).to_i
  end

  def gateway
    # safe to take first cause there's only ever 1 payment method
    puts "payment method id : " + item_return.line_item.order.payments.first.payment_method_id.to_s
    @gateway ||= Spree::PaymentMethod.find(item_return.line_item.order.payments.first.payment_method_id)
  end


  def refund_event
    @refund_event ||= item_return.events.refund.build(@refund_data)
  end

  def item_return
    @item_return ||= ItemReturn.includes(:events).find(@item_return_id)
  end
end
