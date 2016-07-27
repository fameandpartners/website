Raven.configure do |config|
  config.dsn             = "https://#{ENV['SENTRY_PUBLIC']}:#{ENV['SENTRY_SECRET']}@app.getsentry.com/68181"
  config.sanitize_fields = Rails.application.config.filter_parameters.map(&:to_s)
  config.environments    = %w(production)
end
