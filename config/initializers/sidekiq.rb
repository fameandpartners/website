Sidekiq.configure_server do |config|
  config.redis = configatron.redis_options
end

Sidekiq.configure_client do |config|
  config.redis = configatron.redis_options
end