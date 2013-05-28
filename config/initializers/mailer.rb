if Rails.env.staging? || Rails.env.production?
  ActionMailer::Base.delivery_method = :smtp
  ActionMailer::Base.smtp_settings = {
    :address              => "smtp.mailgun.org",
    :port                 => 587,
    :domain               => configatron.mailgun.mailbox.domain,
    :user_name            => configatron.mailgun.mailbox.username,
    :password             => configatron.mailgun.mailbox.password,
    :authentication       => :plain,
    :enable_starttls_auto => true
  }
end
