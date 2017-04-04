class CreateProductHeightRanges < ActiveRecord::Migration
  def change
    create_table :product_height_ranges do |t|
      t.integer :min
      t.integer :max
      t.string :unit
      t.string :map_to
      t.integer :product_height_range_group_id

      t.timestamps
    end
  end
end
