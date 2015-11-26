class AddItemPaidToReturns < ActiveRecord::Migration
  def change
    add_column :item_returns, :item_price,          :integer
    add_column :item_returns, :item_price_adjusted, :integer
  end
end
