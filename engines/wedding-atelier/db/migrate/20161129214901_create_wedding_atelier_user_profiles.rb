class CreateWeddingAtelierUserProfiles < ActiveRecord::Migration
  def up
    create_table :wedding_atelier_user_profiles do |t|
      t.belongs_to  :spree_user
      t.string      :height
      t.string      :dress_size
      t.boolean      :trend_updates
    end
  end

  def down
    drop_table :wedding_atelier_user_profiles
  end
end
