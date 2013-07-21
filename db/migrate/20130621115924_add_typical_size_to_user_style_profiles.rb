class AddTypicalSizeToUserStyleProfiles < ActiveRecord::Migration
  def change
    add_column :user_style_profiles, :typical_size, :string
  end
end
