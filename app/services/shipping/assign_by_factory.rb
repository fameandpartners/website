module Shipping
  class AssignByFactory
    attr_reader :order

    def initialize(order)
      @order = order
    end

    def create_shipments!
      units_by_factory.collect do |_factory, units|
        create_shipment! units
      end
    end

    def create_shipment!(units)
      ::Spree::Shipment.create!(
        {
          order:           order,
          shipping_method: order.shipping_method,
          address:         order.ship_address,
          inventory_units: units
        },
        without_protection: true
      )
    end

    def units_by_factory
      order.inventory_units.group_by do |i|
        begin
          i.variant.product.factory
        rescue NoMethodError
          :unknown
        end
      end
    end
  end
end
