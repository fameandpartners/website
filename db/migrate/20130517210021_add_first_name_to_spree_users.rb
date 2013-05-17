class AddFirstNameToSpreeUsers < ActiveRecord::Migration
  def change
    add_column :spree_users, :first_name, :string
  end
end
