class CreateSpreeProductRelatedOuterwear < ActiveRecord::Migration
  def change
    create_table :spree_product_related_outerwear do |t|
      t.integer :outerwear_id
      t.integer :product_id
    end

    add_index :spree_product_related_outerwear, [:outerwear_id, :product_id], unique: true, name: unique_index_name
    add_index :spree_product_related_outerwear, [:product_id]
  end

  private

  def unique_index_name
    'spree_product_related_outerwear_unique_index'
  end
end
