class ChangeDressSizeInWeddingAtelierUserProfiles < ActiveRecord::Migration
  def up
    add_column :wedding_atelier_user_profiles, :dress_size_id, :integer
    remove_column :wedding_atelier_user_profiles, :dress_size
  end

  def down
    remove_column :wedding_atelier_user_profiles, :dress_size_id
    add_column :wedding_atelier_user_profiles, :dress_size, :string
  end
end
