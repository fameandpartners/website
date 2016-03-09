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
    @moodboard_item.likes                  = 0
    @moodboard_item.user_likes             = ""
  end

  def advance_removal(event)
    @moodboard_item.deleted_at = event.created_at
  end

  def advance_like(event)
    existing_likes = @moodboard_item.user_likes.split(',')
    new_likes = existing_likes | [event.user_id.to_s]
    @moodboard_item.user_likes = new_likes.join(',')
    @moodboard_item.likes      = new_likes.count
  end
end
