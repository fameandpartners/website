class OrderSerializer < ActiveModel::Serializer
  attributes  :id,
              :number,
              :completed_at,
              :updated_at,
              :payment_state,
              :state,
              :currency,
              :final_return_by_date,
              :total,
              :shipment_total,
              :promotion_total,
              :item_total,

              #legacy
              :display_total,
              :display_shipment_total,
              :display_promotion_total,
              :display_item_total

  has_one     :ship_address, serializer: AddressSerializer
  has_one     :billing_address, serializer: AddressSerializer
  has_many    :line_items,  serializer: LineItemSerializer
  has_many    :taxes,  serializer: TaxSerializer

  def billing_address
    object.billing_address
  end

  def shipping_address
    object.ship_address
  end

  def shipments
    object.completed? ? object.shipments : []
  end

  def final_return_by_date
    object.completed? ? (object.final_return_by_date).to_time.iso8601 : nil
  end

  def promotion_total
    (object.promotion_total || 0)  * 100
  end

  def total
    (object.total || 0) * 100
  end

  def item_total
    (object.item_total || 0) * 100
  end

  def shipment_total
    (object.shipment_total || 0) * 100
  end

  def display_total
    object.display_total.to_s
  end
  def display_shipment_total
    object.display_shipment_total.to_s
  end
  def display_promotion_total
    object.display_promotion_total.to_s
  end
  def display_item_total
    object.display_item_total.to_s
  end

end
