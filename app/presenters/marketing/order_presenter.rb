require 'forwardable'

module Marketing
  class OrderPresenter
    extend Forwardable

    def_delegators :@order,
                   :number,
                   :currency

    attr_reader :order, :items

    def initialize(order)
      @order = order
      @items = order.line_items
    end

    def line_items
      items.collect { |i| LineItemPresenter.new(i, self) }
    end

    def total_amount
      order.total.to_f
    end

    def taxes_amount
      order.adjustments.tax.sum(:amount).to_f
    end

    def shipping_amount
      order.adjustments.shipping.sum(:amount).to_f
    end

    def self.build_line_items(order)
      order.line_items.collect do |item|
        {
          sku:                    item.variant.sku,
          name:                   item.variant.product.name,
          making_options_text:    item.making_options_text,
          options_text:           item.options_text,
          quantity:               item.quantity,
          variant_display_amount: item.variant.display_amount,
          display_amount:         item.display_amount
        }
      end
    end

    def self.build_adjustments(order)
      if order.adjustments.present?
        order.adjustments.eligible.collect do |adjustments_item|
          {
            label:          adjustments_item.label,
            display_amount: adjustments_item.display_amount
          }
        end
      else
        []
      end
    end
  end
end
