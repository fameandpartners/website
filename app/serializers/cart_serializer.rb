class CartSerializer < ActiveModel::Serializer
  attributes :item_total, :total, :adjustment_total
  attributes :state, :email, :currency
  attributes :line_items

  attributes :item_count

  attributes :display_shipment_total,
    :display_item_total,
    :display_adjustment_total,
    :display_promotion_total,
    :display_total

  def display_shipment_total
    if object.shipment.present? && object.shipment.amount.to_i > 0
      object.shipment.display_amount.to_s
    else
      'Free Shipping' # JST will set FREE
    end
  end

  def display_item_total
    object.display_item_total.to_s
  end

  def display_adjustment_total
    object.display_adjustment_total.to_s
  end

  def display_promotion_total
    object.display_promotion_total.to_s
  end

  def display_total
    object.display_total.to_s
  end

  def line_items
    object.line_items.includes(variant: :product).collect do |line_item|
      LineItemSerializer.new(line_item)
    end.to_json
  end
end
