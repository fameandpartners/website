require 'delegate'

class ItemPriceAdjustmentSplit < SimpleDelegator
  def item_price_in_cents
    in_cents(price)
  end

  def item_price_adjusted_in_cents
    in_cents(price + per_item_adjustment)
  end

  private

  def in_cents(amount)
    (amount * 100).to_i
  end

  def per_item_adjustment
    order.adjustment_total / num_items_in_order
  end

  def num_items_in_order
    [order.line_items.count, 1].max
  end
end
