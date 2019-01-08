class AddManifacturingSortOrder < ActiveRecord::Migration
  def change
    add_column :customisation_values, :manifacturing_sort_order, :integer
    add_column :customisation_values, :price_aud, :decimal, :precision => 8, :scale => 2
  end
end
