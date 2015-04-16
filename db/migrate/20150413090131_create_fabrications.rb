class CreateFabrications < ActiveRecord::Migration
  def change
    create_table :fabrications do |t|
      t.integer :line_item_id
      t.string :purchase_order_number
      t.string :state
      t.string :factory_name
      t.date :sla_date
      t.string :uuid
      t.timestamps
    end
    add_index :fabrications, :uuid, :unique => true
    add_index :fabrications, :line_item_id, :unique => true
    add_index :fabrications, :purchase_order_number
  end
end

