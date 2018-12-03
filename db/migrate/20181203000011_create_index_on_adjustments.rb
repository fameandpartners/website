class CreateIndexOnAdjustments < ActiveRecord::Migration
  def change
    add_index :spree_adjustments,    [:source_id, :source_type]
  end
end
