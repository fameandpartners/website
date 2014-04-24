class CartSerializer < ActiveModel::Serializer
  attributes :item_total, :total, :adjustment_total
  attributes :state, :email, :currency
  attributes :line_items

  attributes :item_count

  attributes :display_shipment_total,
    :display_item_total,
    :display_adjustment_total,
    :display_promotion_total,
    :display_total,
    :sale_active

  def sale_active
    Spree::Sale.first.try(:active?)
  end

  def display_shipment_total
    if object.shipment.present?
      object.shipment.display_amount.to_s
    else
      nil
    end
  end

  def display_item_total
    object.display_item_total.to_s
  end

  def display_adjustment_total
    if object.display_adjustment_total.money.cents > 0
      object.display_adjustment_total.to_s
    else
      nil
    end
  end

  def display_promotion_total
    if object.promotion_total.to_i.abs > 0
      object.display_promotion_total.to_s
    else
      nil
    end
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
