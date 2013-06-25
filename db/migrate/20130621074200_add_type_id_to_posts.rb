class AddTypeIdToPosts < ActiveRecord::Migration
  def change
    add_column :blog_posts, :post_type_id, :integer
    add_index  :blog_posts, :post_type_id
  end
end
