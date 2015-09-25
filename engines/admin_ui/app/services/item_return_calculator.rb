class ItemReturnCalculator < EventSourcedRecord::Calculator
  events :item_return_events

  def advance_creation(event)
    @item_return.comments = ""
    @item_return.line_item_id = event.line_item_id
  end

  def advance_return_requested(event)
    event.data.map do |k,v|
      @item_return.send("#{k}=", v)
    end
  end

  def advance_receive_item(event)
    @item_return.acceptance_status = :received
    @item_return.received_location = event.location
    @item_return.received_on       = event.received_on
  end

  def advance_approve(event)
    @item_return.acceptance_status = :approved
    @item_return.comments = "#{@item_return.comments}#{event.comment}\n"
  end

  def advance_record_refund(event)
    @item_return.refund_status = :completed
    @item_return.refund_method = event.refund_method
    @item_return.refund_amount = Money.parse(event.refund_amount).amount * 100
    @item_return.refund_ref    = event.refund_reference
    @item_return.refunded_at   = event.refunded_at
  end

  def advance_legacy_data_import(event)
    return if event.deleted_row.present?

    @item_return.order_number      = event.spree_order_number
    @item_return.acceptance_status = event.acceptance_status

    @item_return.requested_action = {
      "return"           => :return,
      "cancellation"     => :cancellation,
      "store credit"     => :store_credit,
      "exchange"         => :exchange,
      "refund"           => :refund,
      "return (promo)"   => :return,
      "return (custom)"  => :return,
      "return/ exchange" => :return,
      "retun"            => :return,
      "charged twice"    => :refund,
      "charged double"   => :refund,
      "cancelation"      => :cancellation
    }.fetch(event.return_cancellation_credit.to_s.downcase.strip) { :unknown }

    @item_return.line_item_id         = event.line_item_id
    @item_return.requested_at         = event.requested_at
    @item_return.reason_category      = event.return_category
    @item_return.reason_sub_category  = event.return_sub_category
    @item_return.request_notes        = event.customers_notes
    @item_return.customer_name        = event.name
    @item_return.contact_email        = event.email
    @item_return.comments             = "#{event.comments}\n#{event.notes}"
    @item_return.order_payment_method = event.payment_method
    @item_return.order_payment_date   = event.order_payment_date
    @item_return.order_paid_amount    = event.order_paid_amount
    @item_return.order_paid_currency  = event.order_paid_currency
    @item_return.order_payment_ref    = event.order_payment_ref
    @item_return.refund_method        = event.refund_method
    @item_return.refund_status        = event.refund_status.to_s.downcase.gsub('yes', 'complete').titleize.strip.presence
    @item_return.refund_amount        = event.refund_amount_in_cents if event.refund_amount_in_cents > 0
    @item_return.refunded_at          = event.refunded_at
    @item_return.product_name         = event.product
    @item_return.product_style_number = event.product_style_number
    @item_return.product_size         = event.size
    @item_return.product_colour       = event.colour
    @item_return.product_customisations = event.product_customisations
    @item_return.qty                  = event.quantity
    @item_return.received_location    = event.return_office

  rescue ArgumentError => e
    NewRelic::Agent.notice_error(e)
  end
end
