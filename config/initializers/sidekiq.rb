Sidekiq.configure_server do |config|
  config.redis = configatron.redis_options

  ActiveRecord::Base.configurations['production']['pool'] = 15
end

Sidekiq.configure_client do |config|
  config.redis = configatron.redis_options
end
