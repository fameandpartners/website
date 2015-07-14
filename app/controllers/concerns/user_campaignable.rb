module Concerns::UserCampaignable
  extend ActiveSupport::Concern

  included do
    before_filter :manage_campaigns
  end

  def current_promotion
    @current_promotion ||= begin
      active_promotion = nil
      CampaignsFactory.get_all_campaign_classes.each do |campaign_class|
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

  def manage_campaigns
    # only for GET requests
    return if !request.get? || !request.format.html?

    # deactivate expirable campaigns if needed
    campaign_classes = CampaignsFactory.get_expirable_campaign_classes

    campaign_classes.each do |campaign_class|
      campaign = campaign_class.new(
        storage:              cookies,
        campaign_attrs:       params.dup,
        current_order:        current_order(true),
        current_site_version: current_site_version
      )
      campaign.deactivate! if campaign.expired?
    end

    # activate new campaigns based on URL params
    campaign_class = CampaignsFactory.get_campaign_class(
      ModalGenerator::ModalParams::CAMPAIGN_UUID.param,
      ModalGenerator::ModalParams::TRIGGER_BY_EVENT.param
    )
    return unless campaign_class

    campaign = campaign_class.new(
      storage:              cookies,
      campaign_attrs:       params.dup,
      current_order:        current_order(true),
      current_site_version: current_site_version
    )

    campaign.activate! if campaign.can_activate?
  end
end
