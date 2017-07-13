class ChangeDeliveryPeriodsDefault < ActiveRecord::Migration
  def change
    change_column_default :spree_taxons, :delivery_period, Spree::Taxon::DELIVERY_PERIODS.first
  end
end
