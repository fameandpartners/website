class AddSignUpReasonToSpreeUsers < ActiveRecord::Migration
  def change
    add_column :spree_users, :sign_up_reason, :string
  end
end
