namespace :dev do
  desc 'Get a completely clean slate, no cache, no assets, no images, no elasticsearch index.'
  task clean_slate: %w(assets:clean cache:expire elasticsearch:reindex)
end
