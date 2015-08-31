class AddCustomisationAllowedToSale < ActiveRecord::Migration
  def up
    add_column :spree_sales, :customisation_allowed, :boolean, default: false
  end

  def down
    #remove_column :spree_sales, :customisation_allowed
    remove_column :spree_sales, :allow_customisation
  end
end
