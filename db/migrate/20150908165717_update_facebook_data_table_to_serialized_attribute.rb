class UpdateFacebookDataTableToSerializedAttribute < ActiveRecord::Migration
  class FacebookData < ActiveRecord::Base
  end

  def up
    # Cleanup unused data
    FacebookData.delete_all

    add_column :facebook_data, :key, :string
    add_index :facebook_data, :key
  end

  def down
    remove_column :facebook_data, :key
  end
end
