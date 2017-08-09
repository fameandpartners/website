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
    tax_adj = order&.adjustments&.tax&.first
    tax_total = 0
    if tax_adj
      tax_rate = Spree::TaxRate.find(tax_adj.originator_id).amount
      tax_total = ((price*100).to_i * tax_rate).round / 100.0
    end

    price + tax_total
  end

  def num_items_in_order
    [order.line_items.count, 1].max
  end
end
