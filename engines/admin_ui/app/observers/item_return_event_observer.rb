class ItemReturnEventObserver < ActiveRecord::Observer
  observe :item_return_event

  def after_create(event)
    ItemReturnCalculator.new(event).run.save!
  end
end

