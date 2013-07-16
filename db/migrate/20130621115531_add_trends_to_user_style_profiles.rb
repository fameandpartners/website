class AddTrendsToUserStyleProfiles < ActiveRecord::Migration
  def change
    add_column :user_style_profiles, :trends, :string
  end
end
