Raven.configure do |config|
  config.dsn             = 'https://b08315fcb45b4588a4c497564b70fc3a:c42e1bae0cd740b682e1dff3fd9e7bc1@app.getsentry.com/68181'
  config.sanitize_fields = Rails.application.config.filter_parameters.map(&:to_s)
  config.environments    = %w(production)
end
