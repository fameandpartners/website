namespace :cache do
  desc 'Clear the rails cache'
  task :clear => :environment do
    puts Rails.cache.clear
  end

  desc 'Clear the rails cache'
  task :expire => :clear

  desc 'Clear all cache and reindex products'
  task :clear_cache_and_reindex => :environment do
    ClearCacheWorker.new.perform
  end
end
