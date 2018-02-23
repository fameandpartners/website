class CreateBatchCollections < ActiveRecord::Migration
  def change
    create_table :batch_collections do |t|
      t.string :batch_key
      t.string :status#, default: 'open'


      t.timestamps
    end
    add_index :batch_collections, :batch_key
  end
end
