class AddConfirmationTokenToSpreeUsers < ActiveRecord::Migration
  def change
    add_column :spree_users, :confirmation_token, :string
  end
end
