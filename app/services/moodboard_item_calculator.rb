class MoodboardItemCalculator < EventSourcedRecord::Calculator
  events :moodboard_item_events

  def advance_creation(event)
    @moodboard_item.color_id               = event.color_id
    @moodboard_item.moodboard_id           = event.moodboard_id
    @moodboard_item.product_color_value_id = event.product_color_value_id
    @moodboard_item.product_id             = event.product_id
    @moodboard_item.user_id                = event.user_id
    @moodboard_item.variant_id             = event.variant_id
    @moodboard_item.deleted_at             = nil
  end

  def advance_removal(event)
    @moodboard_item.deleted_at = event.created_at
  end
end
