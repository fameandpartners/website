class Marketing::CancelOrderTracker
  def initialize(order)
    @order = order
  end

  def send_customerio_event
    begin
      Marketing::CustomerIOEventTracker.new.track(
        @order.user,
        'order_cancel_email',
        email_to:           @order.email,
        subject:            "Your order has been canceled",
        order_number:       @order.number,
        today:              Date.today.to_formatted_s(:long),
        line_items:         Marketing::OrderPresenter.build_line_items(@order),
        adjustments:        Marketing::OrderPresenter.build_adjustments(@order),
        display_item_total: @order.display_item_total,
        display_total:      @order.display_total
      )
    rescue StandardError => e
      NewRelic::Agent.notice_error(e)
    end
  end
end
