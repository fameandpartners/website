module UserCart; end
class UserCart::CartPresenter < OpenStruct
  def serialize
    {
      products: products.map(&:serialize),
      site_version: site_version,
      order_number: order_number,
      item_count: item_count,
      promocode: promocode,
      display_item_total: display_item_total.to_s,
      display_item_total_cent: display_item_total.money.fractional,
      display_shipment_total: (display_shipment_total.present? ? display_shipment_total.to_s : 'Free Shipping'),
      display_shipment_total_cent: (display_shipment_total.present? ? display_shipment_total.money.fractional : 0),
      display_promotion_total: display_promotion_total.to_s,
      display_promotion_total_cent: display_promotion_total.money.fractional,
      display_total: display_total.to_s,
      display_total_cent: display_total.money.fractional,
      taxes: taxes,
      delivery_delay: Features.active?(:cny_delivery_delays),
      delivery_discount: "$#{('%.2f' %(display_item_total.money.fractional.to_f/1000).round(2)).to_s}"
    }
  end
end
