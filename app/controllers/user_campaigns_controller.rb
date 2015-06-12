class UserCampaignsController  < ActionController::Base
  include Concerns::SiteVersion
  include Spree::Core::ControllerHelpers::Order
  include Spree::Core::ControllerHelpers::Auth

  # @params
  #  :cu - capmaign uuid
  # other attributes based on campaign itself
  def create
    campaign_class = CampaignsFactory.getCampaignClass(params[:uuid])

    if campaign_class
      campaign = campaign_class.new(
        storage:              cookies,
        campaign_attrs:       params,
        current_order:        current_order(true),
        current_site_version: current_site_version
      )

      campaign.activate! if campaign.can_activate?
    end

    head :ok
  end
end
