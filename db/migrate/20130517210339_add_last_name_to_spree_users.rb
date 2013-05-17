class AddLastNameToSpreeUsers < ActiveRecord::Migration
  def change
    add_column :spree_users, :last_name, :string
  end
end
