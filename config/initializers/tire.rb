# we don't have separate instances of elasticsearch on stage/feature server
# so we need to divide feature from staging
if Rails.env.feature?
  Tire::Model::Search.index_prefix 'fame_feature'
end

es_host = YAML::load(File.open("#{Rails.root}/config/elasticsearch.yml"))[Rails.env][:hosts]
Tire.configure do
  url es_host
end
