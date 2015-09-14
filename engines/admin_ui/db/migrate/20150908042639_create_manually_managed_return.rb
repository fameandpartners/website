class CreateManuallyManagedReturn < ActiveRecord::Migration
  def change
    create_table :manually_managed_returns do |t|
      t.references :item_return
      t.references :item_return_event
      t.string :import_status
      t.string :row_number
      t.string :rj_ident
      t.string :column_b
      t.string :receive_state
      t.string :spree_order_number
      t.string :return_cancellation_credit
      t.string :name
      t.string :order_date
      t.string :order_month
      t.string :return_requested_on
      t.text   :comments
      t.string :product
      t.string :size
      t.string :colour
      t.string :return_category
      t.string :return_sub_category
      t.string :return_office
      t.string :received
      t.string :in_inventory
      t.text   :notes
      t.string :restocking
      t.string :returned_to_factory
      t.string :refund_status
      t.string :payment_method
      t.string :refund_method
      t.string :currency
      t.string :amount_paid
      t.string :spree_amount_paid
      t.string :refund_amount
      t.string :date_refunded
      t.string :email
      t.string :account_name
      t.string :account_number
      t.string :account_bsb
      t.string :account_swift
      t.text   :customers_notes
      t.string :quantity
      t.string :deleted_row
      t.timestamps
    end
  end
end
