class CreateClassificationTable < ActiveRecord::Migration
  def change

  	create_table :classifications do |t|
      t.string :category
      t.string :subcategory
      
    end

    change_table :spree_products do |t|
	  t.integer :classifcation_id
	end
  end
end
