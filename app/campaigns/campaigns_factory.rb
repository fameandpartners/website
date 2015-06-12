class CampaignsFactory
  TELL_MOMS_CAMPAIGN_UUID = 'tell_mom'
  AUTO_APPLY_PROMO_CODE   = 'auto_apply_promo'

  class << self
    def getCampaignClass(campaign_uuid)
      case campaign_uuid
      when TELL_MOMS_CAMPAIGN_UUID
        TellMomCampaign
      when AUTO_APPLY_PROMO_CODE
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
