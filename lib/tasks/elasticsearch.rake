namespace :elasticsearch do
  desc 'Reindex Elasticsearch'
  task :reindex => :environment do
    Utility::Reindexer.reindex
  end
end
