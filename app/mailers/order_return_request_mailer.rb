class OrderReturnRequestMailer < ActionMailer::Base

  default :from => configatron.noreply

  def email(order_return_request, user)
    @order_return_request = order_return_request

    mail(
      to: 'team@fameandpartners.com',
      from: user.email,
      subject: "[Order Return Request] #{@order_return_request.number}",
      layout: false
    )
  end

end
