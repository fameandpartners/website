class AddBraSizeToUserStyleProfiles < ActiveRecord::Migration
  def change
    add_column :user_style_profiles, :bra_size, :string
  end
end
