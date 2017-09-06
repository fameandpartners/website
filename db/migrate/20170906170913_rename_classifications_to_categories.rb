class RenameClassificationsToCategories < ActiveRecord::Migration
  def change
	rename_table :classifications, :categories

	change_table :spree_products do |t|
	  t.rename :classification_id, :category_id
	end
  end
end
