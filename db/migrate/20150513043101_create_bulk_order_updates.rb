class CreateBulkOrderUpdates < ActiveRecord::Migration
  def change
    create_table :bulk_order_updates do |t|
      t.text :user
      t.text :filename
      t.datetime :processed_at

      t.timestamps
    end

    create_table :line_item_updates do |t|
      t.integer :row_number
      t.text :order_date
      t.text :order_number
      t.text :style_name
      t.text :size
      t.text :quantity
      t.text :colour
      t.text :tracking_number
      t.text :dispatch_date
      t.text :delivery_method

      t.references :bulk_order_update
      t.references :order
      t.references :line_item
      t.references :shipment

      t.text :state
      t.text :process_reason
      t.text :match_errors, array: true
      t.text :shipment_errors, array: true
      t.datetime :processed_at
      t.timestamps
    end

    add_index :line_item_updates, :bulk_order_update_id
  end
end
