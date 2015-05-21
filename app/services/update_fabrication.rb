class UpdateFabrication
  def self.state_change(line_item_id, user, state)
    fabrication = find_or_create_fabrication(line_item(line_item_id))

    fabrication.events.state_change.create!(
        user_id:   user.id,
        user_name: user.email,
        state:     state
    )
  end

  def self.ship(shipment_id, tracking_number, user)
    Spree::LineItem.transaction do

      shipment = Spree::Shipment.find(shipment_id)
      fire_shipment = Admin::ReallyShipTheShipment.new(
        shipment,
        tracking_number
      )

      return fire_shipment.errors unless fire_shipment.valid?

      shipment.line_items.each do |line_item|
        fabrication = find_or_create_fabrication(line_item)

        fabrication.events.state_change.create!(
            user_id:   user.id,
            user_name: user.email,
            state:     'shipped'
        )
      end

      fire_shipment.ship!
    end
  end

  private

  def self.line_item(line_item)
    line_item.is_a?(Spree::LineItem) ? line_item : Spree::LineItem.find(line_item)
  end

  def self.find_or_create_fabrication(line_item)
    line_item.fabrication || FabricationEvent.creation.create!(line_item_id: line_item.id).fabrication
  end
end
