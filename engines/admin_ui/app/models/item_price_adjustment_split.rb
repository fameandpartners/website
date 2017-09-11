require 'delegate'

class ItemPriceAdjustmentSplit < SimpleDelegator
  def item_price_in_cents
    in_cents(price)
  end

  def item_price_adjusted_in_cents
    in_cents(price + per_item_adjustment)
  end

  def per_item_adjustment_in_cents
    in_cents(per_item_adjustment)
  end

  def per_item_tax_adjustment_in_cents
    in_cents(per_item_tax_adjustment['item_tax'])
  end

  def per_item_tax_free_adjustment_in_cents
    in_cents(per_item_tax_free_adjustment(per_item_tax_adjustment['total_tax']))
  end

  def per_item_discounts_in_cents
    in_cents(per_item_discount_adjustment)
  end

  def per_item_adjustment
    # deal with tax adjustments
    taxes = per_item_tax_adjustment

    # deal with all other adjustments
    splittable_adjustment = per_item_tax_free_adjustment(taxes['total_tax'])

    (taxes['total_tax']/order.line_items.count) + splittable_adjustment
  end

  def per_item_tax_adjustment     

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

    {
      'item_tax' => item_tax,
      'total_tax' => total_tax
    }
  end

  def per_item_discount_adjustment
    discount = order&.adjustments&.promotion&.inject(0){|sum, item| sum + item.amount.abs}
    discount/order.line_items.count
  end

  def per_item_tax_free_adjustment_no_param
     per_item_tax_free_adjustment(per_item_tax_adjustment['total_tax'])
  end

  private

  def in_cents(amount)
    (amount * 100).to_i
  end

  def per_item_tax_free_adjustment(total_tax)
    ((order.adjustment_total - total_tax) / num_items_in_order)
  end


  def num_items_in_order
    [order.line_items.count, 1].max
  end

end
