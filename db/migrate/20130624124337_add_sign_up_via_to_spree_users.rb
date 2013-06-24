class AddSignUpViaToSpreeUsers < ActiveRecord::Migration
  def change
    add_column :spree_users, :sign_up_via, :integer
  end
end
