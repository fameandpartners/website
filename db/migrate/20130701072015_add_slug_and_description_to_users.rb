class AddSlugAndDescriptionToUsers < ActiveRecord::Migration
  def change
    add_column :spree_users, :description, :text
    add_column :spree_users, :slug, :string
    add_index  :spree_users, :slug
  end
end
