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

  attributes  :shipments,
							#:billing_address,
              #:shipping_address,
              #:tracking_number,

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

  def shipments
    object.shipments
  end

end
