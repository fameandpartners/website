require 'forwardable'

module Marketing
  class OrderPresenter
    extend Forwardable

    def_delegators :@order,
                   :currency,
                   :email,
                   :number

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

    def shipping_address
      AddressPresenter.new(order.ship_address)
    end

    def billing_address
      AddressPresenter.new(order.bill_address)
    end

    # TODO: `.build_line_items` and `.build_adjustments` should be instance methods
    def self.build_line_items(order)
      order.line_items.collect do |item|
        image_urls        = Products::ColorVariantImageDetector.cropped_images_for(item.product)
        product_image_url = image_urls.sample # TODO: this should reflect the chosen line item color. Right now, is randomly picking a product image

        {
          sku:                    item.variant.sku,
          name:                   item.variant.product.name,
          making_options_text:    item.making_options_text,
          options_text:           item.options_text,
          quantity:               item.quantity,
          variant_display_amount: item.variant.display_amount.to_s,
          display_amount:         item.display_amount.to_s,
          image_url:              product_image_url,
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
