class CampaignsFactory
  class << self
    def getCampaignClass(campaign_uuid)
      case campaign_uuid
      when AutoApplyPromoCampaign::UUID, AutoApplyPromoCampaign::ENCODED_UUID
        AutoApplyPromoCampaign
      end
    end

    def getExpirableCampaignClasses
      [AutoApplyPromoCampaign]
    end

    def getAllCampaignClasses
      [
        AutoApplyPromoCampaign
      ]
    end
  end
end
