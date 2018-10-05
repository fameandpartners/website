class AddIndexToFabrics < ActiveRecord::Migration
  def change
    add_index :fabrics, :name
  end
end
