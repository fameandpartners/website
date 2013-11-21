# we don't have separate instances of elasticsearch on stage/feature server
# so we need to divide feature from staging
if Rails.env.staging? && Rails.root.to_s.match('feature')
  Tire::Model::Search.index_prefix "fame_feature"
end
