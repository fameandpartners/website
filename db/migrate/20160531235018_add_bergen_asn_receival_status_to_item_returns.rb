class AddBergenAsnReceivalStatusToItemReturns < ActiveRecord::Migration
  def change
    add_column :item_returns, :bergen_actual_quantity, :integer
    add_column :item_returns, :bergen_damaged_quantity, :integer
  end
end
