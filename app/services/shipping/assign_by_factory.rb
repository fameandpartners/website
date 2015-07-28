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

    def create_shipment!(units = [])
      shipment = ::Spree::Shipment.create!(
        {
          order:           order,
          shipping_method: order.shipping_method,
          inventory_units: units
        },
        without_protection: true
      )
      # avoiding address validation
      shipment.update_column(:address_id, order.ship_address_id) if order.ship_address_id
      shipment
    end

    def units_by_factory
      return { :unknown => [] } if order.inventory_units.empty?

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
