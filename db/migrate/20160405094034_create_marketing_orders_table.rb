class CreateMarketingOrdersTable < ActiveRecord::Migration
  def change
    create_table :marketing_order_traffic_parameters do |t|
      t.integer :order_id
      t.string  :utm_campaign
      t.string  :utm_source
      t.string  :utm_medium
      t.timestamps
    end
  end
end
