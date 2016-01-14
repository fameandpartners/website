class AddFaultReasonToItemReturns < ActiveRecord::Migration
  def change
    add_column :item_returns, :factory_fault_reason, :string
  end
end
