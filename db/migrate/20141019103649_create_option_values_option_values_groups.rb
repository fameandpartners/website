class CreateOptionValuesOptionValuesGroups < ActiveRecord::Migration
  def change
    create_table :option_values_option_values_groups, id: false do |t|
      t.integer :option_value_id
      t.integer :option_values_group_id
    end
  end
end
