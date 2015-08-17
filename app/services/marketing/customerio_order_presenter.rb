module Marketing
class CustomerIOOrderPresenter
  attr_reader :order, :site_version

  def initialize(order, site_version)
    @order = order
    @site_version = site_version
  end


  def promo_total
    @promo_total ||= @order.adjustments.where("originator_type = 'Spree::PromotionAction'").sum(:amount)
  end

  def item(line_item)
    {
      sku: line_item.variant.sku || line_item.variant.product.sku,
      name: line_item.variant.product.name,
      quantity: line_item.quantity,
      price: line_item.price
    }
  end

  def items
    order.line_items.collect{ |i| item(i) }
  end

  def address
    {
      city: order.bill_address.city,
      state: order.bill_address.state.to_s,
      country: order.bill_address.country.name,
    }
  end

  def order_data
    {
      number: order.number,
      site_version: site_version.code,
      currency: site_version.currency,
      total: order.total,
      discount: promo_total,
      address: address,
      items: items
    }
  end

end
end
