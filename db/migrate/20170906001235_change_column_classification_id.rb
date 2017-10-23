class ChangeColumnClassificationId < ActiveRecord::Migration
  def change
	change_table :spree_products do |t|
	  t.rename :classifcation_id, :classification_id
	end
  end
end
