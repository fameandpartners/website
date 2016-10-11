class RenameSpreeProductRelationForRender3dImages < ActiveRecord::Migration
  def change
    rename_column :render3d_images, :spree_product_id, :product_id
  end
end
