class UpdateFacebookDataTableToSerializedAttribute < ActiveRecord::Migration
  class FacebookData < ActiveRecord::Base
  end

  def up
    # Cleanup unused data
    FacebookData.delete_all
  end

  def down
  end
end
