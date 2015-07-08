require 'forwardable'

module Marketing
  class LineItemPresenter
    extend Forwardable

    def_delegators :@item,
                   :quantity

    attr_reader :item, :wrapper_order

    def initialize(item, wrapper_order)
      @item          = item
      @wrapper_order = wrapper_order
    end

    def sku
      variant.sku.blank? ? product.sku : variant.sku
    end

    def product_name
      product.name
    end

    def category_name
      product.taxons.first.try(:name)
    end

    def total_amount
      item.total.to_f
    end

    private

    def variant
      item.variant
    end

    def product
      variant.product
    rescue StandardError => e
      NewRelic::Agent.notice_error(e, custom_params: { order_number: wrapper_order.number })
    end
  end
end
