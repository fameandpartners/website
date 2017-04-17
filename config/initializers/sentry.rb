Raven.configure do |config|
  app_id = '156022' #devs

  if Rails.env.production?
    app_id = '68181'  #production
  end
  config.dsn             = "https://#{ENV['SENTRY_PUBLIC']}:#{ENV['SENTRY_SECRET']}@sentry.io/#{app_id}"
  config.sanitize_fields = Rails.application.config.filter_parameters.map(&:to_s)
  config.environments    = [Rails.env]
end


