require 'forwardable'

# TODO This is being used by the /mailers/spree/order_mailer_decorator.rb, but its behaviour is almost the same as the GTM object.
# TODO Replace it by the GTM object (gtm/line_item.rb)
module Marketing
  class LineItemPresenter
    extend Forwardable

    def_delegators :@item,
                   :quantity

    attr_reader :item, :wrapped_order

    def initialize(item, wrapped_order)
      @item          = item
      @wrapped_order = wrapped_order
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
      NewRelic::Agent.notice_error(e, custom_params: { order_number: wrapped_order.number })
    end
  end
end
