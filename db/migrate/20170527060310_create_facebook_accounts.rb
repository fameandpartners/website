class CreateFacebookAccounts < ActiveRecord::Migration
  def change
    create_table :facebook_accounts do |t|
      t.string :facebook_id
      t.string :name
      t.integer :account_status
      t.integer :amount_spent
      t.string :currency
      t.float :age
      
      t.timestamps
    end
  end
end
