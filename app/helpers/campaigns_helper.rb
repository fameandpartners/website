module CampaignsHelper
  def modal_with_trigger_event?
    params[ModalGenerator::ModalParams::TRIGGER_BY_EVENT.param].present?
  end

  def campign_attrs
    @campaign_attrs ||= begin
      promocode = decode(params[:pc])
      {
        promocode:     promocode,
        template_name: params[:tn].present? ? decode(params[:tn]) : 'default',
        heading:       decode(params[:h]),
        message:       decode(params[:m]),
        content:       decode(params[:c]) || promocode,
        class_name:    decode(params[:s]),
        fb_id:         decode(params[:fb]),
        timeout:       params[:t] || 3,
        timer:         decode(params[:ti]),
        campaign_uuid: decode(params[:cu]),
        action:        campaigns_email_capture_path
      }
    end
  end

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
