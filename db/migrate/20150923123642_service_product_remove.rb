require_relative '20141114172825_add_visibility_settings_to_product.rb'

class ServiceProductRemove < ActiveRecord::Migration
  def up
    if ActiveRecord::Base.connection.column_exists?(:spree_products, :is_service)
      remove_column :spree_products, :is_service
    end
  end

  def down
    if !ActiveRecord::Base.connection.column_exists?(:spree_products, :is_service)
      add_column :spree_products, :is_service, :boolean, default: false
    end
  end
end
