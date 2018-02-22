class CreateBatchCollections < ActiveRecord::Migration
  def change
    create_table :batch_collections do |t|
      t.string :style

      t.timestamps
    end
    add_index :batch_collections, :style
  end
end
