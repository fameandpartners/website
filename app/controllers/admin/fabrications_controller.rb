module Admin
  class FabricationsController < Spree::Admin::BaseController

    skip_before_filter :check_site_version

    respond_to :json

    def update
      status_event = if params[:shipment]
        UpdateFabrication.ship(
          params[:shipment][:id],
          params[:shipment][:tracking],
          current_spree_user
        )
      else
        UpdateFabrication.state_change(
            params[:id].to_i,
            current_spree_user,
            params[:fabrication_state]
        )
      end

      render json: status_event
    end

    def model_class
      ::Spree::LineItem
    end
  end
end

