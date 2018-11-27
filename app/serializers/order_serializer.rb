class OrderSerializer < ActiveModel::Serializer
  attributes  :id,
              :number,
              :created_at,
              :completed_at,
              :updated_at,
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
              :final_return_by_date

  def billing_address
    object.billing_address
  end

  def shipping_address
    object.ship_address
  end

  def shipments
    object.shipments
  end

  def final_return_by_date
    (object.final_return_by_date&).to_time.iso8601
  end

end
