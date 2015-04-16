module Admin
  class FabricationController < Spree::Admin::BaseController

    skip_before_filter :check_site_version

    respond_to :json

    def update
      status_event = UpdateFabrication.call(
          params[:id].to_i,
          current_spree_user,
          params[:fabrication_state]
      )

      render json: status_event
    end

    def model_class
      ::Spree::LineItem
    end
  end
end

