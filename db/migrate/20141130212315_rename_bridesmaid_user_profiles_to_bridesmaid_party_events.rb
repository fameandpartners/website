class RenameBridesmaidUserProfilesToBridesmaidPartyEvents < ActiveRecord::Migration
  def up
    rename_table :bridesmaid_user_profiles, :bridesmaid_party_events
  end

  def down
    rename_table :bridesmaid_party_events, :bridesmaid_user_profiles
  end
end
