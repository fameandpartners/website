class CreateBlogPreferences < ActiveRecord::Migration
  def change
    create_table :blog_preferences, force: true do |t|
      t.string   "key"
      t.text     "value"
      t.string   "value_type"
      t.datetime "created_at", :null => false
      t.datetime "updated_at", :null => false
    end

    add_index :blog_preferences, :key
  end
end
