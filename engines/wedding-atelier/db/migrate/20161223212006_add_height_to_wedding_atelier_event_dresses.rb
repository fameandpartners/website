class AddHeightToWeddingAtelierEventDresses < ActiveRecord::Migration
  def change
    add_column :wedding_atelier_event_dresses, :height, :string
  end
end
