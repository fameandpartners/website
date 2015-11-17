class MoodboardItemEventObserver < ActiveRecord::Observer
  observe :moodboard_item_event

  def after_create(event)
    MoodboardItemCalculator.new(event).run.save!
  end
end

