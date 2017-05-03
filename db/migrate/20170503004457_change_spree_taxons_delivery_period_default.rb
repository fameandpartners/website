class ChangeSpreeTaxonsDeliveryPeriodDefault < ActiveRecord::Migration
  def change
    change_column :spree_taxons, :delivery_period, :string, :default => "8 - 10 business days"
  end
end
