class AddPaidForBridesmaid < ActiveRecord::Migration
  def up
    add_column :bridesmaid_user_profiles, :paying_for_bridesmaids, :boolean, default: false
  end

  def down
    remove_column :bridesmaid_user_profiles, :paying_for_bridesmaids
  end
end
