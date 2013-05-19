class ConfirmPreviousAccounts < ActiveRecord::Migration
  def up
    Spree::User.update_all(:confirmed_at => Time.now)
  end

  def down
    Spree::User.update_all(:confirmed_at => nil)
  end
end
