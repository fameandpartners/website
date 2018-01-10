class ChangeCustomizationsFromJsonToJsonb < ActiveRecord::Migration
  def change
  	change_column :spree_line_items, :customizations, :jsonb, using: 'column_name::jsonb'
  end
end
