if Rails.env.development?
  require 'sidekiq/testing'
  Sidekiq::Testing.inline!
end

Sidekiq.configure_server do |config|
  config.redis = { url: "#{ENV['REDIS_URL']}/0" }
  config.error_handlers << Proc.new {|ex,ctx_hash| Raven.capture_exception(ex) }
end

Sidekiq.configure_client do |config|
  config.redis = { url: "#{ENV['REDIS_URL']}/0" }
end
