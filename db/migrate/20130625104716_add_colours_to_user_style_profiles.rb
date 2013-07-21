class AddColoursToUserStyleProfiles < ActiveRecord::Migration
  def change
    add_column :user_style_profiles, :colours, :string
  end
end
