class AddHairColourToUserStyleProfiles < ActiveRecord::Migration
  def change
    add_column :user_style_profiles, :hair_colour, :string
  end
end
