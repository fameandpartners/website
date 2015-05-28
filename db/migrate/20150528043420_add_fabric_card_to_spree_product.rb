class AddFabricCardToSpreeProduct < ActiveRecord::Migration
  def change
    change_table :spree_products do |t|
      t.references :fabric_card
    end
  end
end
