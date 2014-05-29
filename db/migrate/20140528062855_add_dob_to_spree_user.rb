class AddDobToSpreeUser < ActiveRecord::Migration
  def change
    add_column :spree_users, :dob, :date
  end
end
