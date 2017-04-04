class CreateStyleToProductHeightRangeGroups < ActiveRecord::Migration
  def change
    create_table :style_to_product_height_range_groups do |t|
      t.string :style_number
      t.integer :product_height_range_group_id

      t.timestamps
    end
  end
end
