# we don't have separate instances of elasticsearch on stage/feature server
# so we need to divide feature from staging
if Rails.env.feature?
  Tire::Model::Search.index_prefix 'fame_feature'
end
if Rails.env.production? || Rails.env.preproduction?
  redis_url = configatron.redis_options || YAML::load(File.open("#{Rails.root}/config/elasticsearch.yml"))[Rails.env][:hosts]
  Tire.configure do
    url redis_url
  end
end
if Rails.env.development?
  Tire.configure do
    logger STDERR, :level => 'debug'
  end
end