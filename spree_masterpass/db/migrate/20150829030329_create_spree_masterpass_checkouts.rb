class CreateSpreeMasterpassCheckouts < ActiveRecord::Migration
  def change
    create_table :spree_masterpass_checkouts do |t|
      t.string :access_token
      t.string :transaction_id
      t.string :precheckout_transaction_id
      t.string :cardholder_name
      t.string :account_number
      t.string :billing_address
      t.date :exp_date
      t.string :brand_id
      t.string :contact_name
      t.string :gender
      t.date :birthday
      t.string :national_id
      t.string :phone
      t.string :email

      t.timestamps
    end
  end
end
