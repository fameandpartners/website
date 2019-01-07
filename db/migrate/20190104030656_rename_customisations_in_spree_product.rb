class RenameCustomisationsInSpreeProduct < ActiveRecord::Migration
  def change
    rename_column :spree_products, :customizations, :old_customizations
  end
end
