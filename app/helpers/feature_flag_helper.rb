module FeatureFlagHelper
  def delivery_date_messaging_enabled?
    Features.active?(:delivery_date_messaging)
  end
end
