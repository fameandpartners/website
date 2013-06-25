class CleanUpFromOldBlog < ActiveRecord::Migration
  def change
    drop_table :categories
    drop_table :celebrities
    drop_table :posts
    drop_table :post_states
    drop_table :red_carpet_events
  end
end
