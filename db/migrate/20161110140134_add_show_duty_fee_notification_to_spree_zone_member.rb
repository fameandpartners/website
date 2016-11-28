class AddShowDutyFeeNotificationToSpreeZoneMember < ActiveRecord::Migration
  def change
    add_column :spree_zone_members, :show_duty_fee_notification, :boolean, default: false
  end
end
