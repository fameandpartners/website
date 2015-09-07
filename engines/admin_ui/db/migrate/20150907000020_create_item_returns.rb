class CreateItemReturns < ActiveRecord::Migration
  def change
    create_table :item_returns do |t|
      t.string   :order_number
      t.integer  :line_item_id
      t.integer  :qty
      t.string   :requested_action
      t.datetime :requested_at
      t.string   :reason_category
      t.string   :reason_sub_category
      t.text     :request_notes
      t.string   :customer_name
      t.string   :contact_email
      t.string   :acceptance_status
      t.text     :comments
      t.string   :product_name
      t.string   :product_style_number
      t.string   :product_colour
      t.string   :product_size
      t.boolean  :product_customisations
      t.date     :received_on
      t.string   :received_location
      t.string   :order_payment_method
      t.integer  :order_paid_amount
      t.string   :order_paid_currency
      t.string   :order_payment_ref
      t.string   :refund_status
      t.string   :refund_ref
      t.string   :refund_method
      t.integer  :refund_amount
      t.datetime :refunded_at
      t.string   :uuid
      t.timestamps
    end
    add_index :item_returns, :uuid,    :unique => true
    add_index :item_returns, :line_item_id, :unique => true
    add_index :item_returns, :order_number
  end
end

