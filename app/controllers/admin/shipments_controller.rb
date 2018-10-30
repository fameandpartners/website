module Admin
  class ShipmentsController < Spree::Admin::BaseController

    respond_to :json

    def update
      update_shipment = Admin::ShipmentShipper.ship(
        params[:shipment][:id],
        params[:shipment][:tracking],
        current_spree_user
      )

      status_code = case update_shipment.status
                      when :error, :invalid then :unprocessable_entity
                      when :valid           then :ok
                    end

      result = update_shipment.result

      # Sorry
      if result[:status] == :valid
        result.merge!(:html_replacement =>
                       render_to_string(:partial => 'shipped_shipment_tracking', :layout => false,
                                        :locals => {:shipment => update_shipment.shipment})

        )
      end
      render json: result, status: status_code
    end
  end
end
