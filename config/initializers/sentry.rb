# app_id = '68181'	#production
# if Rails.env.staging?
#   app_id = '156022' #staging, qa1, qa2
# end

Raven.configure do |config|
  app_id = '68181'  #production

  if Rails.env.staging?
    app_id = '156022'
  end
  config.dsn             = "https://#{ENV['SENTRY_PUBLIC']}:#{ENV['SENTRY_SECRET']}@sentry.io/#{app_id}"
  config.sanitize_fields = Rails.application.config.filter_parameters.map(&:to_s)
  config.environments    = [Rails.env]
end


