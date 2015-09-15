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

  def advance_legacy_data_import(event)
    @item_return.order_number = event.spree_order_number

    potential_state = event.receive_state.to_s.downcase.strip.to_sym
    @item_return.acceptance_status = if ItemReturn::STATES.include?(potential_state)
      potential_state
    elsif /app?rr?o[cv]ed/i.match(event.comments)
      :approved
    else
      :unknown
    end

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

    @item_return.requested_at         = Chronic.parse(event.return_requested_on).try(:to_date).try(:iso8601)
    @item_return.reason_category      = event.return_category
    @item_return.reason_sub_category  = event.return_sub_category
    @item_return.request_notes        = event.customers_notes
    @item_return.customer_name        = event.name
    @item_return.contact_email        = event.email
    @item_return.comments             = "#{event.comments}\n#{event.notes}"
    @item_return.order_payment_method = event.payment_method
    @item_return.order_paid_amount    = Money.parse(event.spree_amount_paid.presence || event.amount_paid).fractional
    @item_return.order_paid_currency  = @item_return.line_item.order.currency.to_s
    # @item_return.order_payment_ref    = nil
    @item_return.refund_method        = event.refund_method
    @item_return.refund_status        = event.refund_status.to_s.downcase.strip.gsub('yes', 'complete').titleize
    if event.refund_amount.present?
      @item_return.refund_amount      = Money.parse(
              event.refund_amount.to_s.gsub('$','').tr(',','').gsub(/[a-z]+/i,'').strip,
              @item_return.order_paid_currency).fractional
    end
    @item_return.refunded_at          = Chronic.parse(event.date_refunded).try(:to_date).try(:iso8601)
    @item_return.product_name         = event.product
    @item_return.product_style_number = Spree::Product.where(name: event.product).map(&:sku).first
    @item_return.product_size         = event.size
    @item_return.product_colour       = event.colour
    @item_return.product_customisations = !! @item_return.line_item.personalization.present?
    @item_return.qty                  = event.quantity
    @item_return.received_location    = event.return_office

  rescue ArgumentError => e
    #whatevers
    binding.pry
  end
end
