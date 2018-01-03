class CreateCustomizationImagesTable < ActiveRecord::Migration
  def change
  	create_table :customization_visualizations do |t|
      t.string :customization_ids
      t.string :incompatible_ids
      t.column :render_urls, :json
      t.integer :product_id
      t.string :length

      t.timestamps
    end
  end
end