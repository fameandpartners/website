# call it to schedule cache clearing & index updatin & etc
# ClearCacheWorker.perform_async

require 'products/color_variants_indexer'

class ClearCacheWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(silent: false)
    @silent = !! silent
    update_color_variants_elastic_index
    reset_cache
    update_repositories
  end

  def silent?
    !! @silent
  end

  private
    def update_color_variants_elastic_index
      ::Products::ColorVariantsIndexer.new( silent? ? false : $stdout ).call
    end

    def reset_cache
      Rails.cache.clear
    end

    def update_repositories
      Repositories::Taxonomy.read_all(force: true).size
    end
end
