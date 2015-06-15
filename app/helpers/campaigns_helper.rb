module CampaignsHelper
  def auto_apply_promo_campaign
    @auto_apply_promo_campaign ||= AutoApplyPromoCampaign.new(
      storage:              cookies,
      campaign_attrs:       params,
      current_order:        current_order(true),
      current_site_version: current_site_version
    )
  end

  def tell_mom_campaign
    @tell_mom_campaign ||= TellMomCampaign.new(
      storage:              cookies,
      campaign_attrs:       params,
      current_order:        current_order(true),
      current_site_version: current_site_version
    )
  end
end
