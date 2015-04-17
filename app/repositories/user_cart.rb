module Repositories
class UserCart
  attr_reader :accessor, :order, :site_version

  def initialize(options = {})
    @accessor = options[:accessor]
    @order    = options[:order]
    @site_version = options[:site_version]
  end

  def read
    OpenStruct.new(
      items: order_items
    )
  end

  private

    def order_items
      order.line_items.map do |line_item|
        Repositories::CartItem.new(line_item: line_item).read
      end
    end
end
end
