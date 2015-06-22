class CampaignsFactory
  class << self
    def getCampaignClass(campaign_uuid)
      case campaign_uuid
      when TellMomCampaign::UUID, TellMomCampaign::ENCODED_UUID
        TellMomCampaign
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
        AutoApplyPromoCampaign, TellMomCampaign, BridesmaidsConsultationFormCampaign
      ]
    end
  end
end
