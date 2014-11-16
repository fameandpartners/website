class CreateBridesmaidEventUserProfiles < ActiveRecord::Migration
  def up
    create_table :bridesmaid_user_profiles, force: true do |t|
      t.references  :spree_user
      t.datetime    :wedding_date
      t.integer     :status
      t.integer     :bridesmaids_count
      t.boolean     :special_suggestions

      t.references  :color     # option value id
      t.string      :color_name
      t.string      :color_code

      t.text        :additional_products

      t.timestamps
    end

    add_index :bridesmaid_user_profiles, :spree_user_id
  end

  def down
    drop_table :bridesmaid_user_profiles
  end
end
