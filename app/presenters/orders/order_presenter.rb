require 'forwardable'

module Orders
  class OrderPresenter

    extend Forwardable

    def_delegators :@order,
                   :products,
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
                   :to_param,
                   :has_fast_making_items?

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

    def product
      products.first
    end

    def total_items
      items.sum &:quantity
    end

    def country_code
      order.shipping_address.country.iso
    end

    def projected_delivery_date
      return unless order.completed?
      order.projected_delivery_date.try(:to_date) || Policies::OrderProjectedDeliveryDatePolicy.new(order).delivery_date.try(:to_date)
    end

    def promo_codes
      @promo_codes ||= order.adjustments.where("originator_type = 'Spree::PromotionAction'").collect { |adj|
        "[#{adj.originator.promotion.code}] #{adj.originator.promotion.name}"
      }
    end

    def promotion?
      promo_codes.any?
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

    def return_requested?
      return_request.present?
    end

    def return_request
      @return_request ||= OrderReturnRequest.where(:order_id => order.id).first
    end
  end
end
