class CreateSpreeProductRelatedJackets < ActiveRecord::Migration
  def change
    create_table :spree_product_related_jackets do |t|
      t.integer :jacket_id
      t.integer :product_id
    end

    add_index :spree_product_related_jackets, [:jacket_id, :product_id], unique: true
    add_index :spree_product_related_jackets, [:product_id]
  end
end
