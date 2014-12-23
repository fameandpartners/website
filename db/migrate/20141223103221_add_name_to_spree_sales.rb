class AddNameToSpreeSales < ActiveRecord::Migration
  def change
    add_column :spree_sales, :name, :string
  end
end
