class AddFitIdToEventDresses < ActiveRecord::Migration
  def change
    add_column :wedding_atelier_event_dresses, :fit_id, :integer
  end
end
