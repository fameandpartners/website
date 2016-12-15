class CreateWeddingAtelierEventDresses < ActiveRecord::Migration
  def up
    create_table :wedding_atelier_event_dresses do |t|
      t.integer :product_id
      t.integer :event_id
      t.integer :user_id
      t.integer :color_id
      t.integer :style_id
      t.integer :fabric_id
      t.integer :size_id
      t.integer :length_id
      t.timestamps
    end
  end

  def down
    drop_table :wedding_atelier_event_dresses
  end
end
