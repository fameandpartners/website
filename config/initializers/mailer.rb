# if Rails.env.staging? || Rails.env.production?
#   ActionMailer::Base.delivery_method = :smtp
#   ActionMailer::Base.smtp_settings   = {
#     address:              ENV['SMTP_HOST'],
#     port:                 ENV['SMTP_PORT'],
#     domain:               configatron.mailgun.mailbox.domain,
#     user_name:            configatron.mailgun.mailbox.username,
#     password:             configatron.mailgun.mailbox.password,
#     authentication:       ENV['SMTP_AUTHENTICATION'].to_sym,
#     enable_starttls_auto: ENV['SMTP_STARTTLS']
#   }
# end
