class ReturnMailer < ActionMailer::Base
  def notify_user(order)
    binding.pry

    user = order.return_request_items[0].line_item.order.user

    # line_item = event.item_return.line_item
    # order = line_item.order
    # user = order.user
    # subject = "Refund notification for order #{order.number}"

    Marketing::CustomerIOEventTracker.new.track(
      user,
      'return_started_email',
      email_to: 'navs@fameandpartners.com',
      amount: '$123.45'
      # email_to:                    user.email,
      # subject:                     subject,
      # amount:                      event.refund_amount,
      # order_number:                order.number
    )

    binding.pry
  rescue StandardError => e
    NewRelic::Agent.notice_error(e)
    Raven.capture_exception(e)
  end
end
