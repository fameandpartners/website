class AddShippoTrackingNumberAndShippoLabelUrlToItemReturns < ActiveRecord::Migration
  def change
    add_column :item_returns, :shippo_tracking_number, :string
    add_column :item_returns, :shippo_label_url, :string
  end
end
