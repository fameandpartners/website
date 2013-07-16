class RenameSpreeUserIdToUserIdInUserStyleProfiles < ActiveRecord::Migration
  def change
    rename_column :user_style_profiles, :spree_user_id, :user_id
  end
end
