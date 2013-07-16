class AddBodyShapeToUserStyleProfiles < ActiveRecord::Migration
  def change
    add_column :user_style_profiles, :body_shape, :string
  end
end
