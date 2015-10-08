class CampaignsFactory
  class << self
    def getCampaignClass(campaign_uuid)
      case campaign_uuid
      when AutoApplyPromoCampaign::UUID, AutoApplyPromoCampaign::ENCODED_UUID
        AutoApplyPromoCampaign
      when BridesmaidsConsultationFormCampaign::UUID, BridesmaidsConsultationFormCampaign::ENCODED_UUID
        BridesmaidsConsultationFormCampaign
      end
    end

    def getExpirableCampaignClasses
      [AutoApplyPromoCampaign]
    end

    def getAllCampaignClasses
      [
        AutoApplyPromoCampaign, BridesmaidsConsultationFormCampaign
      ]
    end
  end
end
