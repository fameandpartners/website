class UserCampaignsController  < ActionController::Base
  include Concerns::SiteVersion
  include Spree::Core::ControllerHelpers::Order
  include Spree::Core::ControllerHelpers::Auth
  include Concerns::UserCampaignable

  # @params
  #   :uuid [String] - capmaign uuid
  #   other attributes based on campaign itself
  def create
    campaign_uuid = params.delete(:uuid)
    campaign_class = CampaignsFactory.getCampaignClass(campaign_uuid)

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

  def check_state
    respond_to do |format|
      format.json do
        if params[:uuid]
          campaign_class = CampaignsFactory.getCampaignClass(params[:uuid])

          if campaign_class
            campaign = campaign_class.new(
              storage:              cookies,
              campaign_attrs:       params,
              current_order:        current_order(true),
              current_site_version: current_site_version
            )

            if campaign.is_active?
              render json: {status: 'active'}
            else
              render json: {status: 'none'}
            end
          else
            render json: {status: 'none'}
          end
        else
          render json: {status: 'none'}
        end
      end
    end
  end

end
