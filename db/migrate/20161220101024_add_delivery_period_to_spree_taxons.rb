class AddDeliveryPeriodToSpreeTaxons < ActiveRecord::Migration
  def change
    add_column :spree_taxons, :delivery_period, :string, default: Spree::Taxon::DELIVERY_PERIODS.first
  end
end
