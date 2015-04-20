class FabricationCalculator < EventSourcedRecord::Calculator
  events :fabrication_events

  def advance_creation(event)
    @fabrication.state        = :new
    @fabrication.line_item_id = event.line_item_id
  end

  def advance_state_change(event)
    @fabrication.state = event.state
  end
end
