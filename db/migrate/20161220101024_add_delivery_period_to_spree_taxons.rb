class AddDeliveryPeriodToSpreeTaxons < ActiveRecord::Migration
  def change
    add_column :spree_taxons, :delivery_period, :string, default: '7 - 10'
  end
end
