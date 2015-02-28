module UserCart; end
class UserCart::CartPresenter < OpenStruct
  def serialize
    {
      products: products.map{|product| product.serialize },
      item_count: item_count,
      display_item_total: display_item_total.to_s,
      display_shipment_total: (display_shipment_total.present? ? display_shipment_total.to_s : 'Free Shipping'),
      display_promotion_total: display_promotion_total.to_s,
      display_total: display_total.to_s
    }
  end
end
