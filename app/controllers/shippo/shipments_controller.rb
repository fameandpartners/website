module Shippo
  class ShipmentsController < ActionController::Base

    def update
      order_number = params[:metadata].split(' ')[1]
      if (order = Spree::Order.where(number: order_number).first)
        if (shipment = order.shipments.first)
          shipment.update_attributes(tracking: params[:tracking_number])
        else
          order.shipments.create(tracking: params[:tracking_number])
        end
      end
      render :nothing => true, :status => 200, :content_type => 'text/html'
    end

  end
end
