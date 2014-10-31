class CreateSpreeOptionValuesGroups < ActiveRecord::Migration
  def change
    create_table :spree_option_values_groups do |t|
      t.integer :option_type_id
      t.string :name
      t.string :presentation

      t.timestamps
    end
  end
end
