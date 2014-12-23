class CreateDiscounts < ActiveRecord::Migration
  def change
    create_table :discounts do |t|
      t.integer :variant_id
      t.integer :color_id
      t.integer :customization_id
      t.integer :amount

      t.timestamps
    end

    add_index :discounts, :variant_id
    add_index :discounts, :color_id
    add_index :discounts, :customization_id
  end
end
