class RefundService
  def initialize(item_return_id:, refund_data:)
    @item_return_id = item_return_id
    @refund_data = refund_data
  end

  def process
    if refund_event.valid?
      response = send_refund_request
      if response.success?
        refund_event.save!
        item_return.refund_status = 'Complete'
        item_return.refund_method = refund_event.refund_method
        item_return.refund_amount = Money.parse(refund_amount).amount
        item_return.refund_ref    = response.params['response']['token']
        item_return.refunded_at   = Time.parse(response.params['response']['created_at'])
        item_return.save!

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
  def response_message(response)
    if response.params['messages'].present?
      response.params['messages'].map { |m| m['message'] }.join("\n")
    else
      response.message
    end
  end

  def send_refund_request
    payment_method.refund(refund_amount, item_return.order_payment_ref)
  end

  def refund_amount
    (@refund_data['refund_amount'].to_f * 100).to_i
  end

  def payment_method
    Spree::Gateway::Pin.where(active: true).first
  end

  def refund_event
    @refund_event ||= item_return.events.refund.build(@refund_data)
  end

  def item_return
    @item_return ||= ItemReturn.includes(:events).find(@item_return_id)
  end
end
