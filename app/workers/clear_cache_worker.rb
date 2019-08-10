# call it to schedule cache clearing & index updatin & etc
# ClearCacheWorker.perform_async

require 'products/color_variants_indexer'

class ClearCacheWorker
  include Sidekiq::Worker
  sidekiq_options retry: false

  def perform(silent: false)
    daping_log("start perform")
    @silent = !! silent
    update_color_variants_elastic_index
    reset_cache
    Feeds::Base.export!('au')
    Feeds::Base.export!('us')
  end

  def silent?
    !! @silent
  end

  def daping_log(logs)
    logf=File.new("/home/daping.log", "a+")
    logf.puts(Time.now.to_s + ": daping " + logs)
    logf.close
  end

  private
  def update_color_variants_elastic_index
    daping_log("update_color_variants_elastic_index")
    ::Products::ColorVariantsIndexer.new( silent? ? false : $stdout ).call
  end

  def reset_cache
    Rails.cache.clear
  end
end
