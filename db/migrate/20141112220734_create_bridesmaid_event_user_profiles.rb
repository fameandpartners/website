class CreateBridesmaidEventUserProfiles < ActiveRecord::Migration
  def up
    create_table :bridesmaid_event_user_profiles do |t|
      t.references  :spree_user
      t.datetime    :wedding_date
      t.integer     :status
      t.integer     :bridesmaids_count
      t.boolean     :special_suggestions

      t.timestamps
    end

    add_index :bridesmaid_event_user_profiles, :spree_user_id
  end

  def down
    drop_table :bridesmaid_event_user_profiles
  end
end
