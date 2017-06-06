class CreateFacebookAdInsights < ActiveRecord::Migration
  def change
    create_table :facebook_ad_insights do |t|
      t.integer :facebook_ad_id
      t.integer :clicks
      t.integer :cost_per_action_type
      t.float :cpc
      t.float :cpm
      t.float :cpp
      t.float :ctr
      t.datetime :date_start
      t.datetime :date_stop
      t.float :frequency
      t.float :reach
      t.column :relevance_score, :json
      t.column :social_impressions, :json
      t.float :spend
      t.float :total_actions
      t.float :total_unique_actions
      t.column :website_ctr, :json
      t.integer :website_clicks

      t.timestamps
    end
  end
end
