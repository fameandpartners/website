class ShipmentsController < ActionController::Base

  def update
    order_number = params[:metadata].split(' ')[1]
    order = Spree::Order.where(number: order_number).first
    if order.present?
      if order.shipment.present?
        order.shipment.update_attributes(tracking: params[:tracking_number])
      else
        order.shipment.create(tracking: params[:tracking_number])
      end
    end
    render :nothing => true, :status => 200, :content_type => 'text/html'
  end

end
