class AddUniquenessIndexToGlobalSkusSku < ActiveRecord::Migration
  def change
    add_index :global_skus, :sku, unique: true
  end
end
