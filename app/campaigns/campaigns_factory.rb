require 'base64'

Dir[File.join(Rails.root, 'app/campaigns/*.rb')].each do |file|
  require file
end

class CampaignsFactory
  class << self
    def get_campaign_class(campaign_uuid, trigger_by_event = nil)
      if !trigger_by_event.nil?
        TriggerByEventCampaign
      else
        get_campaign_class_by_uuid(campaign_uuid) || get_campaign_class_by_uuid(Base64.decode64(campaign_uuid.to_s))
      end
    end

    def get_campaign_class_by_uuid(campaign_uuid)
      get_all_campaign_classes.detect do |campaign_class|
        campaign_class::UUID == campaign_uuid
      end
    end

    def get_expirable_campaign_classes
      get_all_campaign_classes.select do |campaign_class|
        campaign_class.is_expirable?
      end
    end

    def get_all_campaign_classes
      CampaignManager.subclasses
    end
  end
end
