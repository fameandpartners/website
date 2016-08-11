require 'forwardable'

module Marketing
  class OrderPresenter
    extend Forwardable

    def_delegators :@order,
                   :currency,
                   :email,
                   :first_name,
                   :number,
                   :site_version,
                   :required_to

    attr_reader :order, :items

    def initialize(order)
      @order = order
      @items = order.line_items
    end

    def auto_account
      order.user && order.user.automagically_registered?
    end

    def user
      order.user
    end

    def line_items
      items.collect { |i| LineItemPresenter.new(i, self) }
    end

    def total_amount
      order.total.to_f
    end

    def display_total
      order.display_total.to_s
    end

    def display_item_total
      order.display_item_total.to_s
    end

    def taxes_amount
      order.adjustments.tax.sum(:amount).to_f
    end

    def shipping_amount
      order.adjustments.shipping.sum(:amount).to_f
    end

    def shipping_address_attributes
      AddressPresenter.new(order.ship_address)
    end

    def billing_address_attributes
      AddressPresenter.new(order.bill_address)
    end

    def billing_address
      order.try(:billing_address).to_s || 'No Billing Address'
    end

    def shipping_address
      order.try(:shipping_address).to_s || 'No Shipping Address'
    end

    def shipment_method_name
      order.shipment.try(:shipping_method).try(:name)
    end

    def shipment_tracking
      order.shipment.tracking
    end

    def shipment_tracking_url
      order.shipment.blank? ? '#' : order.shipment.tracking_url
    end

    def phone
      order.try(:billing_address).try(:phone) || 'No Phone'
    end

    def phone_present?
      order.try(:billing_address).try(:phone).present?
    end

    def projected_delivery_date
      order.projected_delivery_date.try(:strftime, '%a, %d %b %Y')
    end

    def original_order_date
      order.created_at.strftime('%d %b %Y')
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
        {
          sku:                    item.sku,
          name:                   item.product_name,
          making_options_text:    item.making_options_text,
          options_text:           item.options_text,
          quantity:               item.quantity,
          variant_display_amount: item.variant_display_amount,
          display_amount:         item.display_amount,
          size:                   item.size_name,
          color:                  item.colour_name,
          height:                 item.height,
          customisation:          item.customisation_text,
          image_url:              item.image_url
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
