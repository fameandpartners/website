class AddLikesCountToWeddingAtelierEventDresses < ActiveRecord::Migration
  def change
    add_column :wedding_atelier_event_dresses, :likes_count, :integer, default: 0
  end
end
