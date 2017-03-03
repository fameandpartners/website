class RefundMailer < ActionMailer::Base
  def notify_user(event)
    line_item = event.item_return.line_item
    order = line_item.order
    user = order.user
    subject = "Refund notification for order #{order.number}"

    Marketing::CustomerIOEventTracker.new.track(
      user,
      'refund_notification_email',
      email_to:                    user.email,
      subject:                     subject,
      amount:                      event.refund_amount,
      order_number:                order.number
    )
  rescue StandardError => e
    NewRelic::Agent.notice_error(e)
    Raven.capture_exception(e)
  end
end
