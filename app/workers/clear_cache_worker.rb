# call it to schedule cache clearing & index updatin & etc
# ClearCacheWorker.perform_async
class ClearCacheWorker
  include Sidekiq::Worker
  sidekiq_options retry: 3

  def perform(*args)
    update_color_variants_elastic_index
    update_products_elastic_index
    reset_cache
    update_repositories
  end

  private

    def update_products_elastic_index
      Tire.index(configatron.elasticsearch.indices.spree_products) do
        delete
        import ::Spree::Product.all
      end

      Tire.index(configatron.elasticsearch.indices.spree_products).refresh
    end

    def update_color_variants_elastic_index
      Products::ColorVariantsIndexer.index!
    end

    def reset_cache
      ActiveSupport::Cache::RedisStore.new(Rails.application.config.cache_store.last).clear
      Rails.cache.clear
      Redis.new(configatron.redis_options).flushdb
    end

    def update_repositories
      Repositories::Taxonomy.read_all(force: true).size
      Repositories::Discount.discounts(force: true).size
    end
end
