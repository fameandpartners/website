class CreateNextLogisticsReturnRequest < ActiveRecord::Migration
  def change
    create_table :next_logistics_return_requests do |t|
      t.references :order_return_request
      t.string :aasm_state

      # Error handling
      t.boolean :failed, default: false
      t.string :error_id

      t.timestamps
    end
  end
end
