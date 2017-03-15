class AddBulkRefundToItemReturns < ActiveRecord::Migration
  def change
    add_column :item_returns, :bulk_refund, :boolean, null: false, default: false
  end
end
