class CreateProductAccessories < ActiveRecord::Migration
  def change
    create_table :product_accessories do |t|
      t.references :style
      t.references :spree_product

      t.integer :position
      t.boolean :active, default: true
      t.string  :title
      t.string  :name
      t.string  :source
      t.decimal :price, :precision => 8, :scale => 2
      t.string  :currency

      t.string    :image_file_name
      t.string    :image_content_type
      t.integer   :image_file_size
      t.datetime  :image_updated_at

      t.timestamps
    end

    if ActiveRecord::Base.connection.column_exists?(:styles, :accessories)
      remove_column :styles, :accessories
    end
    if ActiveRecord::Base.connection.table_exists? :style_images
      drop_table :style_images
    end
  end
end
