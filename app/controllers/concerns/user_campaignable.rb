module Concerns::UserCampaignable
  extend ActiveSupport::Concern

  included do
    before_filter :just_apply_the_damn_promo_code
    before_filter :manage_campaigns
  end

  def current_promotion
    @current_promotion ||= begin
      active_promotion = nil
      CampaignsFactory.getAllCampaignClasses.each do |campaign_class|
        campaign = campaign_class.new(
          storage:              cookies,
          campaign_attrs:       params,
          current_order:        current_order(true),
          current_site_version: current_site_version
        )
        if campaign.is_active? && promotion = campaign.promotion
          active_promotion = promotion
        end
      end

      if !active_promotion
        active_promotion = current_order.coupon_code_added_promotion
      end
      active_promotion
    end
  end

  def just_apply_the_damn_promo_code
    # only for GET requests
    return unless request.get?
    begin
      if session[:auto_apply_promo].present?
        service = UserCart::PromotionsService.new(
          order: current_order,
          code: session[:auto_apply_promo]
        )

        if service.apply
          session.delete :auto_apply_promo
        end
      end
    rescue StandardError => e
      NewRelic::Agent.notice_error(e)
    end
  end

  def manage_campaigns
    # only for GET requests
    return unless request.get?

    # deactivate expirable campaigns if needed
    campaign_classes = CampaignsFactory.getExpirableCampaignClasses

    campaign_classes.each do |campaign_class|
      campaign = campaign_class.new(
        storage:              cookies,
        campaign_attrs:       params,
        current_order:        current_order(true),
        current_site_version: current_site_version
      )
      campaign.deactivate! if campaign.expired?
    end

    # activate new campaigns based on URL params
    campaign_class = CampaignsFactory.getCampaignClass(params[:cu])
    return unless campaign_class

    campaign = campaign_class.new(
      storage:              cookies,
      campaign_attrs:       params,
      current_order:        current_order(true),
      current_site_version: current_site_version
    )

    campaign.activate! if campaign.can_activate?
  end
end
