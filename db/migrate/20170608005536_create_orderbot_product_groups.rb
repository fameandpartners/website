class CreateOrderbotProductGroups < ActiveRecord::Migration
  def change
    create_table :orderbot_product_groups do |t|
      t.integer :product_class_id
      t.string :product_class_name
      t.integer :category_id
      t.string :category_name
      t.integer :group_id
      t.string :group_name

      t.timestamps
    end
  end
end
