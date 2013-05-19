class AddUnconfirmedEmailToSpreeUsers < ActiveRecord::Migration
  def change
    add_column :spree_users, :unconfirmed_email, :string
  end
end
