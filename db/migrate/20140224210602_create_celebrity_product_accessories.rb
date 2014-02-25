class CreateCelebrityProductAccessories < ActiveRecord::Migration
  def change
    create_table :celebrity_product_accessories, force: true do |t|
      t.references :celebrity
      t.references :spree_product

      t.integer :position
      t.boolean :active, default: true
      t.string  :title
      t.string  :source

      t.string    :image_file_name
      t.string    :image_content_type
      t.integer   :image_file_size
      t.datetime  :image_updated_at

      t.timestamps
    end

    add_index :celebrity_product_accessories, [:celebrity_id, :spree_product_id], name: 'celebrity_product_accessories_main'
  end
end
