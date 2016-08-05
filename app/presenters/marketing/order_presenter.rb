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

    def promotion?
      promo_codes.any?
    end

    def promo_codes
      @promo_codes ||= order.adjustments.where("originator_type = 'Spree::PromotionAction'").collect { |adj|
        "[#{adj.originator.promotion.code}] #{adj.originator.promotion.name}"
      }
    end

    def build_line_items
      line_items.collect do |item|
        image_urls        = Products::ColorVariantImageDetector.cropped_images_for(item.product)
        product_image_url = image_urls.sample # TODO: this should reflect the chosen line item color. Right now, is randomly picking a product image

        {
          sku:                    item.sku,
          name:                   item.product_name,
          making_options_text:    item.making_options_text,
          options_text:           item.options_text,
          quantity:               item.quantity,
          variant_display_amount: item.variant_display_amount,
          display_amount:         item.display_amount,
          size:                   item.size,
          color:                  item.color,
          height:                 item.height,
          image_url:              product_image_url
        }
      end
    end

    def build_adjustments
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
