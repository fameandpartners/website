require 'forwardable'

module Orders
  class OrderPresenter

    extend Forwardable

    def_delegators :@order,
                   :display_total,
                   :customer_notes,
                   :id,
                   :number,
                   :completed_at,
                   :name,
                   :first_name,
                   :shipments,
                   :site_version,
                   :state,
                   :to_param

    attr_reader :order, :items

    def initialize(order, items = nil)
      @order = order
      @items = items || order.line_items
    end

    alias_method :customer_notes?, :customer_notes

    def line_items
      items.collect { |i| LineItemPresenter.new(i, self) }
    end
    
    def one_item?
      line_items.count == 1
    end

    def total_items
      items.sum &:quantity
    end

    def country_code
      order.shipping_address.country.iso
    end

    def projected_delivery_date
      order.projected_delivery_date.try(:to_date) || Policies::OrderProjectedDeliveryDatePolicy.new(order).delivery_date.try(:to_date)
    end

    def promo_codes
      order.adjustments.where("originator_type = 'Spree::PromotionAction'").collect { |adj|
        adj.originator.promotion.code
      }
    end

    def phone_number
      order.try(:billing_address).try(:phone) || 'No Phone'
    end

    def shipping_address
      order.try(:shipping_address) || 'No Shipping Address'
    end

    def tracking_number
      if order.shipments.any?
        order.shipments.first.tracking
      end
    end
  end
end
