require 'forwardable'

module Orders
  class OrderPresenter

    extend Forwardable

    def_delegators :@order, :customer_notes, :number

    attr_reader :order

    def initialize(order)
      @order = order
    end

    alias_method :customer_notes?, :customer_notes

    def line_items
      order.line_items.map { |i| LineItemPresenter.new(i) }
    end

    def total_items
      order.line_items.sum &:quantity
    end

    def country_code
      order.shipping_address.country.iso
    end

    def projected_delivery_date
      order.projected_delivery_date.try(:to_date) || 'Unknown'
    end

    def name
      order.name
    end

    def phone_number
      order.billing_address.phone
    end

    def shipping_address
      order.shipping_address.to_string
    end
  end
end