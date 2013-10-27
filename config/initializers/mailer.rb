if Rails.env.staging? || Rails.env.production?
  ActionMailer::Base.delivery_method = :smtp
  ActionMailer::Base.smtp_settings = {
    :address              => 'smtp.mailgun.org',
    :port                 => 587,
    :domain               => configatron.mailgun.mailbox.domain,
    :user_name            => configatron.mailgun.mailbox.username,
    :password             => configatron.mailgun.mailbox.password,
    :authentication       => :plain,
    :enable_starttls_auto => true
  }

  ActionMailer::Base.add_delivery_method :mandrill, Mail::SMTP
  ActionMailer::Base.mandrill_settings = {
    :address              => 'smtp.mandrillapp.com',
    :port                 => 587,
    :user_name            => configatron.mandrill.smtp.username,
    :password             => configatron.mandrill.smtp.password
  }
end
