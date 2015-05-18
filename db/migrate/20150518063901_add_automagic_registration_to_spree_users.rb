class AddAutomagicRegistrationToSpreeUsers < ActiveRecord::Migration
  def change
    add_column :spree_users, :automagically_registered, :boolean, :default => false
  end
end
