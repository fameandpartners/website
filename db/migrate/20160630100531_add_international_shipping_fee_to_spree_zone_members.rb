class AddInternationalShippingFeeToSpreeZoneMembers < ActiveRecord::Migration
  def change
    add_column :spree_zone_members, :has_international_shipping_fee, :boolean, default: false
  end
end
