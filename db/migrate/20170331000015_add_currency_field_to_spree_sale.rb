class AddCurrencyFieldToSpreeSale < ActiveRecord::Migration
  def change
    add_column :spree_sales, :currency, :string, default: ''
  end
end
