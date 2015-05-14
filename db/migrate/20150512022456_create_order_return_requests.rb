class CreateOrderReturnRequests < ActiveRecord::Migration
  def change
    create_table :order_return_requests do |t|
      t.references :order
      t.timestamps
    end
  end
end
