class CreateSpreeSales < ActiveRecord::Migration
  def change
    create_table :spree_sales do |t|
      t.boolean :is_active
      t.decimal :discount_size
      t.integer :discount_type

      t.timestamps
    end
  end
end
