class Marketing::CancelOrderTracker
  def initialize(order)
    @order = order
  end

  def send_customerio_event
    order_presenter = Marketing::OrderPresenter.new(@order)

    begin
      Marketing::CustomerIOEventTracker.new.track(
        @order.user,
        'order_cancel_email',
        email_to:           @order.email,
        subject:            "Your order has been canceled",
        order_number:       @order.number,
        today:              Date.today.to_formatted_s(:long),
        line_items:         order_presenter.build_line_items,
        adjustments:        order_presenter.build_adjustments,
        display_item_total: @order.display_item_total.to_s,
        display_total:      @order.display_total.to_s
      )
    rescue StandardError => e
      NewRelic::Agent.notice_error(e)
    end
  end
end
