class ChangeLimitOfValueInSpreeProductProperties < ActiveRecord::Migration
  def up
    change_column :spree_product_properties, :value, :string, limit: 512
  end

  def down
    change_column :spree_product_properties, :value, :string, limit: nil
  end
end
