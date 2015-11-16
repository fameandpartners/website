class RenameMoodboardItemInspiration < ActiveRecord::Migration
  def change
    rename_table :moodboard_items, :inspirations
    rename_index :inspirations, 'index_moodboard_items_on_spree_product_id_and_active', 'index_inspirations_on_spree_product_id_and_active'
  end
end
