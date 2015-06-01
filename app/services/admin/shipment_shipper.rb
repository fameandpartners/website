module Admin
  class ShipmentShipper
    def self.ship(shipment_id, tracking_number, user)
      Spree::Shipment.transaction do

        shipment      = Spree::Shipment.find(shipment_id)
        fire_shipment = Admin::ReallyShipTheShipment.new(
          shipment,
          tracking_number
        )

        fire_shipment.ship! do
          shipment.line_items.each do |line_item|
            fabrication = Fabrication.for(line_item)

            fabrication.events.state_change.create!(
              user_id:   user.id,
              user_name: user.email,
              state:     'shipped'
            )
          end
        end
        fire_shipment
      end
    end
  end
end
