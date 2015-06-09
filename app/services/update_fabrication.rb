class UpdateFabrication
  def self.state_change(line_item_id, user, new_state)
    fabrication = Fabrication.for(line_item(line_item_id))

    return if fabrication.state == new_state

    fabrication.events.state_change.create!(
        user_id:   user.id,
        user_name: user.email,
        state:     new_state
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
