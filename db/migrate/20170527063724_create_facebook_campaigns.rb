class CreateFacebookCampaigns < ActiveRecord::Migration
  def change
    create_table :facebook_campaigns do |t|
      t.string :facebook_id      
      t.string :name
      t.datetime :created_time
      t.datetime :start_time
      t.datetime :stop_time
      t.datetime :updated_time
      t.string :status
      t.column :recommendations, :json
      t.string :facebook_account_id

      t.timestamps
    end
  end
end
