Sidekiq.configure_server do |config|
  config.redis = { :namespace => 'fame_and_partners' }
end

Sidekiq.configure_client do |config|
  config.redis = { :namespace => 'fame_and_partners' }
end
