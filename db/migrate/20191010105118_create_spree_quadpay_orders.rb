class CreateSpreeQuadpayOrders < ActiveRecord::Migration
   def change
    create_table :spree_quadpay_orders do |t|
      t.integer :payment_id
      t.string :qp_order_id
      t.string :qp_order_token
    end
  end
end
