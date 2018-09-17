namespace :elasticsearch do
  desc 'Reindex Elasticsearch, everything'
  task :reindex => :environment do
    Utility::Reindexer.reindex
  end
end
