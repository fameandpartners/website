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
    # deal with tax adjustments
    tax_adj = order&.adjustments&.tax&.first

    item_tax = 0
    total_tax = 0
    if tax_adj
      tax_rate = Spree::TaxRate.find(tax_adj.originator_id).amount
      item_tax = (((price*100).to_i * tax_rate) / 100.0).round(2)

      total_tax = order.line_items.inject(0) do |total, li|
        total + ((((li.price*100).to_i * tax_rate) / 100.0))
      end
      total_tax = total_tax.round(2)
    end

    # deal with all other adjustments
    splittable_adjustment = ((order.adjustment_total - total_tax) / num_items_in_order)

    item_tax + splittable_adjustment
  end

  def num_items_in_order
    [order.line_items.count, 1].max
  end
end
