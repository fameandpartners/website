class AddInternationalShippingFeeToSpreeZoneMembers < ActiveRecord::Migration
  def change
    add_column :spree_zone_members, :international_shipping_fee, :boolean
  end
end
