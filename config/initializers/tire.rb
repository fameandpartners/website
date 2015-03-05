# we don't have separate instances of elasticsearch on stage/feature server
# so we need to divide feature from staging
if Rails.env.feature?
  Tire::Model::Search.index_prefix 'fame_feature'
end
if Rails.env.production? || Rails.env.preproduction?
  Tire.configure do
    url configatron.es_url
  end
end
if Rails.env.development?
  Tire.configure do
    logger STDERR, :level => 'debug'
  end
end