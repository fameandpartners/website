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
      item_count: cart_products.sum{|product| product.quantity},
      display_total: order.display_total.to_s
    )
  end

  private

    def cart_products
      @cart_products ||= begin
        Spree::LineItem.includes(:personalization, :variant => :product).where(order_id: order.id).map do |line_item|
          Repositories::CartProduct.new(line_item: line_item).read
        end
      end
    end
end
