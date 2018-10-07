module UserCart; end
class  UserCart::UserCartResource
  attr_reader :site_version, :order

  def initialize(options = {})
    @site_version = options[:site_version] || SiteVersion.default
    @order        = options[:order]
  end

  def read
    UserCart::CartPresenter.new(
      products: cart_products,
      item_count: cart_products.reject{|p| p.name == 'RETURN_INSURANCE'}.sum{|product| product.quantity},
      promocode: order.promocode,
      display_item_total: order.display_item_total,
      display_shipment_total: order_display_shipment_total,
      display_promotion_total: order.display_promotion_total,
      display_total: order.display_total,
      taxes: serialize_taxes,
      site_version: site_version,
      order_number: order.number
    )
  end

  private

    def serialize_taxes
      order.adjustments.eligible.tax
        .map { |tax| Orders::TaxPresenter.new(spree_adjustment: tax, spree_order: order) }
        .map(&:to_h)
    end

    def order_display_shipment_total
      if order_shipment_amount > 0
        order.shipment.display_amount
      end
    end

    def order_shipment_amount
      order.try(:shipment).try(:amount).to_f
    end

    def cart_products
      @cart_products ||= begin
        order.line_items.includes(:personalization, :making_options, :fabric, :variant => { product: [:category, :making_options]}).map do |line_item|
          Repositories::CartProduct.new(line_item: line_item).read
        end
      end
    end
end
