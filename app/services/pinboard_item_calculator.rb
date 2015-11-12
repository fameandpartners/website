class PinboardItemCalculator < EventSourcedRecord::Calculator
  events :pinboard_item_events

  def advance_creation(event)

  end
end
