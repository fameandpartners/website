class AddFacebookDataSerializedFieldToSpreeUsers < ActiveRecord::Migration
  def change
    add_column :spree_users, :facebook_data, :text
  end
end
