class IndexOrderShipmentState < ActiveRecord::Migration
  def change
    add_index :spree_orders, :shipment_state
  end
end
