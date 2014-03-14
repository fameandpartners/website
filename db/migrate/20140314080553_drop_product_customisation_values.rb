class DropProductCustomisationValues < ActiveRecord::Migration
  def up
    drop_table :product_customisation_values
  end

  def down
    create_table :product_customisation_values do |t|
      t.integer :product_customisation_type_id
      t.integer :customisation_value_id
      t.string  :image_file_name
      t.string  :image_content_type
      t.integer :image_file_size
      t.decimal :price, :precision => 8, :scale => 2
      t.integer :product_id
      t.string  :name
      t.string  :presentation
    end
  end
end
