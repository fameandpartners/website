class CreateProductToOrderbotProductGroups < ActiveRecord::Migration
  def change
    create_table :product_to_orderbot_product_groups do |t|
      t.integer :product_id
      t.integer :orderbot_product_group_id

      t.timestamps
    end
  end
end
