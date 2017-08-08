class ReturnMailer < ActionMailer::Base
  def notify_user(order)
    binding.pry

    user = order.return_request_items[0].line_item.order.user
    email = user.email
    order_number  = order.id
    subject = "Refund notification for order #" + Spree::Order.where(id: order.order_id)[0].number
    returnTotal = 0
    ItemReturn.where(id: order_number).select{ |item| returnTotal += item.item_price_adjusted }
    returnArray = []
    ItemReturn.where(id: order_number).select{ |item| returnArray.push(item) }
    # Get billing address
    addressObject = Spree::Address.where(id: Spree::Order.where(id: order.order_id)[0].bill_address_id)[0]
    addressOne = addressObject.address1
    addressTwo = addressObject.address2
    city = addressObject.city:q
    billingState = Spree::State.where(id: addressObject.state_id)[0].abbr
    zipCode = addressObject.zipcode

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
  rescue StandardError => e
    NewRelic::Agent.notice_error(e)
    Raven.capture_exception(e)
  end
end
