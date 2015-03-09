class AddSiteFlagToSpreeSales < ActiveRecord::Migration
  def change
    add_column :spree_sales, :sitewide, :boolean, :default => false
  end
end
