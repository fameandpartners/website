class CleanUpFromOldBlog < ActiveRecord::Migration
  def change
    drop_table :categories if table_exists? :categories
    drop_table :celebrities if table_exists? :celebrities
    drop_table :posts if table_exists? :posts
    drop_table :post_states if table_exists? :post_states
    drop_table :red_carpet_events if table_exists? :red_carpet_events
  end
end
