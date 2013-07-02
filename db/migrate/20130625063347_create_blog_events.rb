class CreateBlogEvents < ActiveRecord::Migration
  def change
    create_table :blog_events do |t|
      t.string :name
      t.string :slug
      t.integer :user_id
      t.timestamps
    end

    add_index  :blog_events, :slug
    add_index  :blog_events, :user_id
    add_column :blog_posts, :event_id, :integer
    add_index  :blog_posts, :event_id
  end
end
