class FabricationEventObserver < ActiveRecord::Observer
  observe :fabrication_event

  def after_create(event)
    a = FabricationCalculator.new(event).run.save!
  end
end

