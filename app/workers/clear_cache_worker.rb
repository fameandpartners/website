# call it to schedule cache clearing & index updatin & etc
# ClearCacheWorker.perform_async
class ClearCacheWorker
  include Sidekiq::Worker
  sidekiq_options retry: 3

  def perform(*args)
    ActiveSupport::Cache::RedisStore.new(Rails.application.config.cache_store.last).clear
    Products::ColorVariantsIndexer.index!
    Rails.cache.clear
  end
end
