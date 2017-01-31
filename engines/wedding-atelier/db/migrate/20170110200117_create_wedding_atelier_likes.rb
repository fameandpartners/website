class CreateWeddingAtelierLikes < ActiveRecord::Migration
  def up
    create_table :wedding_atelier_likes do |t|
      t.belongs_to :user
      t.belongs_to :event_dress
      t.timestamps
    end

    add_index :wedding_atelier_likes, [:user_id, :event_dress_id], unique: true
  end

  def down
    drop_table :wedding_atelier_likes
  end
end
