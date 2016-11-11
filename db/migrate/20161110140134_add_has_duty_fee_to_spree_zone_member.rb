class AddHasDutyFeeToSpreeZoneMember < ActiveRecord::Migration
  def change
    add_column :spree_zone_members, :has_duty_fee, :boolean, default: false
  end
end
