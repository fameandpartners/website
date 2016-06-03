class AddBergenAsnNumberToItemReturns < ActiveRecord::Migration
  def change
    add_column :item_returns, :bergen_asn_number, :string
  end
end
