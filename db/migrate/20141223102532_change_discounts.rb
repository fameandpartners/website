class ChangeDiscounts < ActiveRecord::Migration
  def change
    remove_column :discounts, :variant_id
    remove_column :discounts, :color_id
    remove_column :discounts, :customization_id

    add_column :discounts, :discountable_id, :integer
    add_column :discounts, :discountable_type, :string

    add_column :discounts, :sale_id, :integer

    add_index :discounts, [:discountable_id, :discountable_type]
    add_index :discounts, :sale_id
  end
end
