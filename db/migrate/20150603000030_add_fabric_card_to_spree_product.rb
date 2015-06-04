class AddFabricCardToSpreeProduct < ActiveRecord::Migration
  def up
    change_table :spree_products do |t|
      t.references :fabric_card
    end
  end

  def down
    remove_column :spree_products, :fabric_card_id
  end
end
