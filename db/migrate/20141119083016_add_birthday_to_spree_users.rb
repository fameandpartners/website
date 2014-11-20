class AddBirthdayToSpreeUsers < ActiveRecord::Migration
  def change
    add_column :spree_users, :birthday, :date
  end
end
