class RenameProductColorValueToColorValueAtRender3dImage < ActiveRecord::Migration
  def change
    rename_column :render3d_images, :product_color_value_id, :color_value_id
  end
end
