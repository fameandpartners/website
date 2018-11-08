class OrderSerializer < ActiveModel::Serializer
  attributes  :id,
              :number,
              :created_at,
              :completed_at,
              :payment_state,
              :payment_total,
              :projected_delivery_date,
              :return_type,
              :shipment_state,
              :state,
              :return_eligible?,
              :adjustment_total,
              :promocode,
              :item_total,
              :currency

  has_one     :ship_address, serializer: AddressSerializer

  attributes  :address,
              :tracking_number,
              :returns

  def address
    object.ship_address
  end

  #def promocode
    #object.promocode
  #end

 # def shipping_method
    #object.shipping_method
  #end

  def tracking_number
    object.shipment.number
  end

  def returns
    return_request = OrderReturnRequest.find_by_order_id(object.id)

    if return_request.nil?
      return
    end

    {
      created_at: return_request.created_at,
      returned: object.returned?
    }
  end

end
