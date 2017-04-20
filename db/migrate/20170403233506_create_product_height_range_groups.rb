class CreateProductHeightRangeGroups < ActiveRecord::Migration
  def change
    create_table :product_height_range_groups do |t|
      t.string :unit
      t.string :name

      t.timestamps
    end
  end
end
