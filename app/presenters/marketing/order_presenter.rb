require 'forwardable'

module Marketing
  class OrderPresenter
    include ApplicationHelper
    extend Forwardable

    def_delegators :@order,
                   :currency,
                   :email,
                   :number,
                   :site_version,
                   :required_to,
                   :delivery_period

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

    def phone
      order.try(:billing_address).try(:phone) || 'No Phone'
    end

    def phone_present?
      order.try(:billing_address).try(:phone).present?
    end

    def projected_delivery_date
      order.projected_delivery_date.try(:strftime, '%a, %d %b %Y')
    end

    def promotion?
      promo_codes.any?
    end

    def delivery_discount
      "$#{('%.2f' %((order.item_total * 0.1).to_f).round(2)).to_s}"
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
          display_height:         convert_height_units(item.personalization&.height_value, item.personalization&.height_unit),
          customisation:          item.customisation_text,
          image_url:              item.image_url,
          delivery_period:        item.item.delivery_period
        }
      end
    end

    def build_adjustments
      if order.adjustments.present?
        if order.adjustments.eligible.first.code.upcase.include? 'DELIVERYDISC'
          arry = []
          arry << {
            label:          'Return Savings (10%)',
            display_amount: "$#{('%.2f' %((spree_order.item_total * 0.1).to_f).round(2)).to_s}"
          }
          arry << {
            label:          'Additional Savings',
            display_amount: order.display_promotion_total
          }
        else
          order.adjustments.eligible.collect do |adjustments_item|
            {
              label:          adjustments_item.label,
              display_amount: adjustments_item.display_amount.to_s
            }
          end
        end
      else
        if order.line_items.any? {|x| x.product.style_name.downcase == 'return_insurance'}
          [
            {
              label:          'Returns Deposit',
              display_amount: '$25.00'
            }
          ]
        else
          []
        end
      end
    end

  end
end
