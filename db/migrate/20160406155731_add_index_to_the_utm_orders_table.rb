class AddIndexToTheUtmOrdersTable < ActiveRecord::Migration
  def change
    add_index :marketing_order_traffic_parameters, :order_id
  end
end
