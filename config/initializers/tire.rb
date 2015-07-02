
Tire.configure do
  url configatron.es.url
  if Rails.env.development? && ENV['DEBUG_TIRE_REQUESTS']
    logger STDERR, :level => 'debug'
  end
end
