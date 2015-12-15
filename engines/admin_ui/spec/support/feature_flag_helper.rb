module FeatureFlagHelper
  def save_feature_flags!
    feat_store = []
    Features.features.each do |feature|
      feat_store << {feature: feature, active: Features.active?(feature)}
    end
    feat_store
  end

  def restore_feature_flags!(feat_store)
    Features.clear!
    feat_store.each do |feature|
      feature[:active] ? Features.activate(feature[:feature]) : Features.deactivate(feature[:feature])
    end
  end
end


RSpec.configure do |c|
  c.include FeatureFlagHelper, type: :controller
end
