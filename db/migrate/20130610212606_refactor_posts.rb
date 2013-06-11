class RefactorPosts < ActiveRecord::Migration
  def up
    add_column :posts, :category_id, :integer
    drop_table :fashion_news
    drop_table :prom_tips
    drop_table :style_tips
  end

  def down
    remove_column :posts, :category_id

    create_table "fashion_news", :force => true do |t|
      t.string   "title"
      t.text     "content"
      t.integer  "user_id"
      t.datetime "created_at",                   :null => false
      t.datetime "updated_at",                   :null => false
      t.integer  "post_state_id", :default => 1
    end

    create_table "prom_tips", :force => true do |t|
      t.string   "title"
      t.text     "content"
      t.integer  "user_id"
      t.datetime "created_at",                   :null => false
      t.datetime "updated_at",                   :null => false
      t.integer  "post_state_id", :default => 1
    end

    create_table "style_tips", :force => true do |t|
      t.string   "title"
      t.text     "content"
      t.integer  "user_id"
      t.datetime "created_at",                   :null => false
      t.datetime "updated_at",                   :null => false
      t.integer  "post_state_id", :default => 1
    end
  end
end
