class AddStatesToPosts < ActiveRecord::Migration
  def self.up
    create_table :post_states do |t|
      t.string :title
    end

    [
      :celebrity_photos, :posts, :fashion_news,
      :prom_tips, :style_tips, :celebrities, :red_carpet_events
    ].each do |table|
      add_column table, :post_state_id, :integer, default: 1
    end
  end

  def self.down
    drop_table :post_states

    [
      :celebrity_photos, :posts, :fashion_news,
      :prom_tips, :style_tips, :celebrities, :red_carpet_events
    ].each do |table|
      remove_column table, :post_state_id
    end
  end
end
