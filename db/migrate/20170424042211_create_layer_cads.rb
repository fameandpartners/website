class CreateLayerCads < ActiveRecord::Migration
  def change
    create_table :layer_cads do |t|
      t.integer :product_id
      t.integer :position
      t.boolean :customization_1
      t.boolean :customization_2
      t.boolean :customization_3
      t.boolean :customization_4
      t.string :base_image_name
      t.string :layer_image_name

      t.timestamps
    end
  end
end
