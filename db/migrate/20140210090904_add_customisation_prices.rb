class AddCustomisationPrices < ActiveRecord::Migration
  def change
    add_column :customisation_values, :price, :decimal, precision: 8, scale: 2
    add_column :product_customisation_values, :price, :decimal, precision: 8, scale: 2, null: true
  end
end
