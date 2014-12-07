class UpdateBridesmaidProfile < ActiveRecord::Migration
  def change
    create_table :bridesmaid_user_profiles, force: true do |t|
      t.references  :spree_user
      t.datetime    :wedding_date
      t.integer     :status
      t.integer     :bridesmaids_count
      t.boolean     :special_suggestions

      t.text        :colors
      t.text        :additional_products
    end
  end
end
