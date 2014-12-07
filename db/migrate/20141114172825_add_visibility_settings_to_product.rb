class AddVisibilitySettingsToProduct < ActiveRecord::Migration
  def up
    if !ActiveRecord::Base.connection.column_exists?(:spree_products, :hidden)
      add_column :spree_products, :hidden, :boolean, default: false
    end
    if !ActiveRecord::Base.connection.column_exists?(:spree_products, :is_service)
      add_column :spree_products, :is_service, :boolean, default: false
    end
  end

  def down
    if ActiveRecord::Base.connection.column_exists?(:spree_products, :hidden)
      remove_column :spree_products, :hidden
    end
    if ActiveRecord::Base.connection.column_exists?(:spree_products, :is_service)
      remove_column :spree_products, :is_service
    end
  end
end
