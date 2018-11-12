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
  has_one     :billing_address, serializer: AddressSerializer

  attributes  :returns,
              #:billing_address,
              #:shipping_address,
              #:tracking_number,
              :shipments,

  #def promocode
    #object.promocode
  #end

  #def shipping_method
  #  object.shipping_method
  #end

  def billing_address
    object.billing_address
  end

  def shipping_address
    object.ship_address
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

  def shipments
    object.shipments
  end

end
