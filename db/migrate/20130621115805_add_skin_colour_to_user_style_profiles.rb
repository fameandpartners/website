class AddSkinColourToUserStyleProfiles < ActiveRecord::Migration
  def change
    add_column :user_style_profiles, :skin_colour, :string
  end
end
