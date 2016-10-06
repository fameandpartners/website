class CreateNextLogisticsReturnRequest < ActiveRecord::Migration
  def change
    create_table :next_logistics_return_requests do |t|
      t.references :order_return_request

      t.timestamps
    end
  end
end
