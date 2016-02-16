class CreateRefundRequests < ActiveRecord::Migration
  def change
    create_table :refund_requests do |t|
      t.references :order
      t.references :payment
      t.string :order_number
      t.string :payment_ref, null: false, unique: true
      t.string :currency
      t.integer :payment_amount
      t.string :acceptance_status
      t.integer :requested_refund_amount
      t.timestamp :payment_created_at
      t.string :customer_name
      t.string :customer_email
      t.string :refund_ref
      t.string :refund_currency
      t.string :refund_success
      t.integer :refund_amount
      t.timestamp :refund_created_at
      t.string :refund_status_message
      t.string :public_key
      t.string :secret_key
      t.string :api_url
      t.timestamps
    end
  end
end
