Spree::OrderMailer.class_eval do
  layout 'mailer', :except => [:team_confirm_email]

  def team_confirm_email(order)
    find_order(order)

    to = 'team@fameandpartners.com'
    from = "#{@order.full_name} <#{@order.email}>"
    subject = "#{Spree::Config[:site_name]} #{t('order_mailer.confirm_email.subject')} ##{@order.number}"

    mail(:to => to, :from => from, :subject => subject)
  end
end
