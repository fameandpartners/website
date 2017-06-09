class CreateFacebookAdCreatives < ActiveRecord::Migration
  def change
    create_table :facebook_ad_creatives do |t|
      t.string :facebook_id
      t.integer :facebook_ad_id
      t.string :image_url

      t.timestamps
    end
  end
end
