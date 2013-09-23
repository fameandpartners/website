Spree::OrderMailer.class_eval do
  layout 'mailer', :except => [:team_confirm_email]

  include Spree::BaseHelper
  include OrdersHelper

  helper 'spree/base'
  helper :orders

  def team_confirm_email(order)
    find_order(order)

    to = 'team@fameandpartners.com'
    from = "#{@order.full_name} <#{@order.email}>"
    subject = "#{Spree::Config[:site_name]} #{t('order_mailer.confirm_email.subject')} ##{@order.number}"

    mail(to: to, from: from, subject: subject)
  end

  def guest_payment_request(payment_request)
    @payment_request = payment_request
    find_order(payment_request.order_id)

    to = "#{@payment_request.recipient_full_name} <#{@payment_request.recipient_email}>"
    from = "#{@order.full_name} <#{@order.email}>"
    subject = "Can you please pay for my order at #{Spree::Config[:site_name]}?"

    mail(to: to, from: from, subject: subject)
  end
end
