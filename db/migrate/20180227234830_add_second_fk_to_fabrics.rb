class AddSecondFkToFabrics < ActiveRecord::Migration
  def change
  	add_column :fabrics, :option_fabric_color_value_id, :integer
  	add_index :fabrics, [:option_value_id], :name => 'ix_fabrics_on_fabric_color_id'
  end
end
