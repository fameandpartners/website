class CampaignsFactory
  class << self
    def getCampaignClass(campaign_uuid)
      case campaign_uuid
      when TellMomCampaign::UUID
        TellMomCampaign
      when AutoApplyPromoCampaign::UUID
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
