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
      total: order.total
    )
  end

  private

    def cart_products
      @cart_products ||= begin
        order.line_items.includes(:personalization, :variant => :product).map do |line_item|
          Repositories::CartProduct.new(line_item: line_item).read
        end
      end
    end
end
