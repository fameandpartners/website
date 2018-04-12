class AddIndexToCustomizationVisualizations < ActiveRecord::Migration
  def change
    add_index :customization_visualizations, :product_id
  end
end
