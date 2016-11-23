class RenameEventsToSpreeWeddingAtelierEvents < ActiveRecord::Migration
  def up
    rename_table :events, :spree_wedding_atelier_events
  end

  def down
    rename_table :spree_wedding_atelier_events, :events
  end
end
