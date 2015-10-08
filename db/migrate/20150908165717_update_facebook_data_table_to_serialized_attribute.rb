class UpdateFacebookDataTableToSerializedAttribute < ActiveRecord::Migration
  class FacebookData < ActiveRecord::Base
  end

  def up
    # Cleanup unused data
    FacebookData.delete_all

    remove_index :facebook_data, :spree_user_id
    add_index :facebook_data, :spree_user_id, unique: true
  end

  def down
    remove_index :facebook_data, :spree_user_id
    add_index :facebook_data, :spree_user_id
  end
end
