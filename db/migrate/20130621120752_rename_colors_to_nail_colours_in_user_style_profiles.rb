class RenameColorsToNailColoursInUserStyleProfiles < ActiveRecord::Migration
  def change
    rename_column :user_style_profiles, :colors, :nail_colours
  end
end
