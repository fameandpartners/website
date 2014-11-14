class AddVisibilitySettingsToProduct < ActiveRecord::Migration
  def up
    if !ActiveRecord::Base.connection.column_exists?(:spree_products, :hidden)
      add_column :spree_products, :hidden, :boolean, default: false
    end
  end

  def down
    if ActiveRecord::Base.connection.column_exists?(:spree_products, :hidden)
      remove_column :spree_products, :hidden
    end
  end
end
