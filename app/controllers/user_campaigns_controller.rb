class UserCampaignsController  < ActionController::Base
  include Concerns::SiteVersion
  include Spree::Core::ControllerHelpers::Order
  include Spree::Core::ControllerHelpers::Auth
  include Concerns::UserCampaignable

  # @params
  #   :uuid [String] - capmaign uuid
  #   other attributes based on campaign itself
  def create
    campaign_class = CampaignsFactory.getCampaignClass(params.delete(:uuid))

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
