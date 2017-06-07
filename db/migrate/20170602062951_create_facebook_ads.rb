class CreateFacebookAds < ActiveRecord::Migration
  def change
    create_table :facebook_ads do |t|
      t.string :facebook_id
      t.string :facebook_adset_id
      t.string :name
      t.datetime :created_time
      t.datetime :updated_time
      t.float :bid_amount
      t.string :status
      t.column :recommendations, :json

      t.timestamps
    end
  end
end
