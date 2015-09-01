module UserCart; end
class  UserCart::UserCartResource
  attr_reader :site_version, :order

  def initialize(options = {})
    @order        = options[:order]
    @site_version = options[:site_version] || @order.get_site_version
  end

  def read
    UserCart::CartPresenter.new(
      products: cart_products,
      item_count: cart_products.sum{|product| product.quantity},
      promocode: order.promocode,
      display_item_total: order.display_item_total,
      display_shipment_total: order_display_shipment_total,
      display_promotion_total: order.display_promotion_total,
      display_total: order.display_total
    )
  end

  private

    def order_display_shipment_total
      if order.shipment && order.shipment.display_amount && order.shipment.display_amount.money.cents > 0
        order.shipment.display_amount
      else
        nil
      end
    end

    def cart_products
      @cart_products ||= begin
        Spree::LineItem.includes(:personalization, :making_options, :variant => :product).where(order_id: order.id).map do |line_item|
          Repositories::CartProduct.new(line_item: line_item, site_version: site_version).read
        end
      end
    end
end
