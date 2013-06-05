class RemoveSpreeEsentialsFootprints < ActiveRecord::Migration
  def up
    %w[
      spree_posts spree_post_products spree_post_categories_posts
      spree_post_categories spree_blogs
    ].each do |name|
      drop_table name
    end
  end

  def down
    raise IrreversibleMigration
  end
end
