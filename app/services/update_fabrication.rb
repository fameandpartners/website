class UpdateFabrication
  def self.call(line_item_id, user, state)
    fabrication = find_or_create_fabrication(line_item_id)

    fabrication.events.state_change.create!(
        user_id:   user.id,
        user_name: user.email,
        state:     state
    )
  end

  private

  def self.find_or_create_fabrication(line_item_id)
    Spree::LineItem.find(line_item_id).fabrication || FabricationEvent.creation.create!(line_item_id: line_item_id).fabrication
  end
end