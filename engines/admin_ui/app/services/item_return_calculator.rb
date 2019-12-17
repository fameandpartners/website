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

  def advance_rejection(event)
    @item_return.acceptance_status = :rejected
    @item_return.comments = "#{@item_return.comments}#{event.comment}\n"
  end

  def advance_refund(event)
    RefundMailer.notify_user(event).deliver
  end

  def advance_record_refund(event)
    @item_return.refund_status = 'Complete'
    @item_return.refund_method = event.refund_method
    @item_return.refund_amount = Money.parse(event.refund_amount).amount * 100
    @item_return.refund_ref    = event.refund_reference
    @item_return.refunded_at   = event.refunded_at
  end

  def advance_factory_fault(event)
    @item_return.factory_fault = event.factory_fault
    @item_return.factory_fault_reason = (@item_return.factory_fault ? event.factory_fault_reason : nil)
  end

  def advance_bergen_asn_created(event)
    @item_return.bergen_asn_number = event.asn_number
  end

  def advance_bergen_asn_received(event)
    @item_return.bergen_actual_quantity = event.actual_quantity
    @item_return.bergen_damaged_quantity = event.damaged_quantity

    Bergen::Operations::ReceiveBergenParcel.new(item_return: @item_return).process
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
    received_location_map = {
      'UK'                       => 'UK',
      'USD'                      => 'US',
      'US'                       => 'US',
      'Return to sender (china)' => 'CN',
      'AU'                       => 'AU',
      'AUS'                      => 'AU',
    }
    @item_return.received_location    = received_location_map[event.return_office]

  rescue ArgumentError => e
    NewRelic::Agent.notice_error(e)
  end

  def advance_backfill_item_price(event)
    @item_return.item_price          = event.item_price
    @item_return.item_price_adjusted = event.item_price_adjusted
  end

  def advance_manual_order_return(event)
    event.data.map do |k,v|
      if k == "line_item_number"
        k = "line_item_id"
      end
      next if %i( manual_order_data user comment ).include?(k.to_sym)
      @item_return.send("#{k}=", v)
    end
  end

  def advance_tracking_number_updated(event)
    @item_return.shippo_tracking_number = event.shippo_tracking_number
    @item_return.shippo_label_url       = event.shippo_label_url
  end
end
