class UserCampaignsController  < ActionController::Base
  respond_to :js, only: [:by_event]

  include Concerns::SiteVersion
  include Spree::Core::ControllerHelpers::Order
  include Spree::Core::ControllerHelpers::Auth
  include Concerns::UserCampaignable

  # @params
  #   :uuid [String] - capmaign uuid
  #   other attributes based on campaign itself
  def create
    campaign_uuid = params.delete(:uuid)
    campaign_class = CampaignsFactory.get_campaign_class(campaign_uuid)

    if campaign_class
      campaign = campaign_class.new(
        storage:              cookies,
        campaign_attrs:       params.dup,
        current_order:        current_order(true),
        current_site_version: current_site_version
      )

      campaign.activate! if campaign.can_activate?
    end

    head :ok
  end

  # @params
  #   :event_name (e.g. add-to-cart)
  def by_trigger_event
    campaign = TriggerByEventCampaign.new(
      storage:              cookies,
      campaign_attrs:       {event_name: params[:event_name]}
    )

    if campaign.is_active?
      campaign_data = campaign.data
      params.merge!(campaign_data)

      # event based campaigns should be used only once
      # so we have to deactivate them automatically
      campaign.deactivate!

      respond_to do |format|
        format.js # default
      end
    else
      head :ok
    end
  end

  def check_state
    respond_to do |format|
      format.json do
        status = 'none'

        if params[:uuid] && campaign_class = CampaignsFactory.get_campaign_class(params[:uuid])
          campaign = campaign_class.new(
            storage:              cookies,
            campaign_attrs:       params,
            current_order:        current_order(true),
            current_site_version: current_site_version
          )

          status = 'active' if campaign.is_active?
        end

        render json: {status: status}
      end
    end
  end

  # @params
  #  :email [String]
  def tell_mom
    if Devise.email_regexp =~ params[:email]
      moodboard = Wishlist::UserWishlistResource.new(
        site_version: current_site_version,
        owner:        current_spree_user
      ).read

      if current_promotion && (auto_discount = current_promotion.discount)
        moodboard.products.each do |product|
          product.discount = [product.discount, auto_discount].compact.max_by{|i| i.amount}
        end
      end

      Spree::OrderMailer.send_to_friend(moodboard.products, params[:email]).deliver
    end

    head :ok
  end
end
