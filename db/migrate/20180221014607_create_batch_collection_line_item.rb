class CreateBatchCollectionLineItem < ActiveRecord::Migration
  def change
    create_table :batch_collection_line_items do |t|
      t.integer :batch_collection_id
      t.integer :line_item_id
      t.datetime :projected_delivery_date

      t.timestamps
    end
  end
end
