module Admin
  class FabricationsController < Spree::Admin::BaseController

    respond_to :json

    def update
      render json: UpdateFabrication.state_change(
            params[:id].to_i,
            current_spree_user,
            params[:fabrication_state]
      )
    end

    def model_class
      ::Spree::LineItem
    end
  end
end

