module FeatureFlagHelpers
  def enable_wedding_atelier_feature_flag
    Features.activate(:wedding_atelier)
  end
end

RSpec.configure do |config|
  config.include FeatureFlagHelpers
end
