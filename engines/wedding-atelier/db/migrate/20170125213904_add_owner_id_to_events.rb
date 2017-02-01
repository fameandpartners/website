class AddOwnerIdToEvents < ActiveRecord::Migration
  def change
    add_column :wedding_atelier_events, :owner_id, :integer
  end
end
