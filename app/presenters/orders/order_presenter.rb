module Orders
  class OrderPresenter < DelegateClass(Spree::Order)
    delegate :id, :to => :__getobj__

    attr_reader :items

    def initialize(order, items_subset = nil)
      super(order)
      @items = items_subset || __getobj__.line_items
    end

    alias_method :customer_notes?, :customer_notes

    def line_items
      items.collect { |i| Orders::LineItemPresenter.new(i, __getobj__) }
    end

    def total_items
      items.sum &:quantity
    end

    def country_code
      shipping_address.country.iso
    end

    def projected_delivery_date
      return unless completed_at.present?
      __getobj__.projected_delivery_date || Policies::OrderProjectedDeliveryDatePolicy.new(__getobj__).delivery_date
    end

    def promo_codes
      adjustments.where("originator_type = 'Spree::PromotionAction'").collect { |adj|
        adj.originator.promotion.code
      }
    end

    def phone_number
      billing_address.phone
    end

    def shipping_address
      shipping_address.to_string
    end

    def tracking_number
      if shipments.any?
        shipments.first.tracking
      end
    end
  end
end
