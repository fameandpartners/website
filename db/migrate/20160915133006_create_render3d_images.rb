class CreateRender3dImages < ActiveRecord::Migration
  def change
    create_table :render3d_images do |t|
      # Paperclip
      t.has_attached_file :attachment

      # Relationships
      t.references :product_color_value
      t.references :customisation_value

      # ActiveRecord
      t.timestamps
    end
  end
end
