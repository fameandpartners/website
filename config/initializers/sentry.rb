Raven.configure do |config|
  config.dsn             = "https://#{ENV['SENTRY_PUBLIC']}:#{ENV['SENTRY_SECRET']}@sentry.io/68181"
  config.sanitize_fields = Rails.application.config.filter_parameters.map(&:to_s)
  config.environments    = %w(production)
end
