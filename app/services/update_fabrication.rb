class UpdateFabrication
  def self.state_change(line_item_id, user, state)
    fabrication = Fabrication.for(line_item(line_item_id))

    fabrication.events.state_change.create!(
        user_id:   user.id,
        user_name: user.email,
        state:     state
    )
  end

  def self.ship(shipment_id, tracking_number, user)
    Admin::ShipmentShipper.ship(shipment_id, tracking_number, user)
  end

  private

  def self.line_item(line_item)
    line_item.is_a?(Spree::LineItem) ? line_item : Spree::LineItem.find(line_item)
  end
end
