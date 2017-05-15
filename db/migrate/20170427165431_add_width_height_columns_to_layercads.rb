class AddWidthHeightColumnsToLayercads < ActiveRecord::Migration
  def change
    add_column :layer_cads, :width, :integer
    add_column :layer_cads, :height, :integer
    
  end
end
