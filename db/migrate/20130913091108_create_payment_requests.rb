class CreatePaymentRequests < ActiveRecord::Migration
  def change
    create_table :payment_requests do |t|
      t.integer :order_id
      t.string :recipient_full_name
      t.string :recipient_email
      t.text :message
      t.string :token

      t.timestamps
    end
  end
end
