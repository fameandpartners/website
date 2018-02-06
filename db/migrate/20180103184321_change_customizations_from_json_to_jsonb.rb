class ChangeCustomizationsFromJsonToJsonb < ActiveRecord::Migration
  def change
  	change_column :spree_line_items, :customizations, 'jsonb USING CAST(customizations as jsonb)'
  end
end
