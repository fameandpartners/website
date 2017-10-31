class OrderBotStatusMailer < ActionMailer::Base
  default :from => configatron.noreply

  def email(order_numbers)
    @order_numbers = order_numbers
    mail(
      to: 'dev@fameandpartners.com',
      subject: "Order bot order report #{Time.now.to_s} #{Rails.env}",
      layout: false
    )
  end

end
