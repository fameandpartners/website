class AddDeletedAtToBatchCollectionLineItems < ActiveRecord::Migration
  def change
    add_column :batch_collection_line_items, :deleted_at, :datetime
    add_index :batch_collection_line_items, :deleted_at
  end
end
