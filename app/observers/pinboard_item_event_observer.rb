class PinboardItemEventObserver < ActiveRecord::Observer
  observe :pinboard_item_event

  def after_create(event)
    PinboardItemCalculator.new(event).run.save!
  end
end

