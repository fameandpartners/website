require 'forwardable'

# TODO This is being used by the /mailers/spree/order_mailer_decorator.rb, but its behaviour is almost the same as the GTM object
# TODO Replace it by the GTM object (gtm/order.rb)
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

    # TODO: `.build_line_items` and `.build_adjustments` should be instance methods
    def self.build_line_items(order)
      order.line_items.collect do |item|
        {
          sku:                    item.variant.sku,
          name:                   item.variant.product.name,
          making_options_text:    item.making_options_text,
          options_text:           item.options_text,
          quantity:               item.quantity,
          variant_display_amount: item.variant.display_amount.to_s,
          display_amount:         item.display_amount.to_s,
          image_url:              item.image.present? ? item.image.attachment.url(:large) : nil,
          height:                 item.personalization.present? ? item.personalization.height : LineItemPersonalization::DEFAULT_HEIGHT,
          color:                  item.personalization.present? ? item.personalization.color.try(:name) || 'Unknown Color' : item.variant.try(:dress_color).try(:name) || 'Unknown Color'
        }
      end
    end

    def self.build_adjustments(order)
      if order.adjustments.present?
        order.adjustments.eligible.collect do |adjustments_item|
          {
            label:          adjustments_item.label,
            display_amount: adjustments_item.display_amount.to_s
          }
        end
      else
        []
      end
    end
  end
end
