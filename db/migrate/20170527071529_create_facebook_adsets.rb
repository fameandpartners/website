class CreateFacebookAdsets < ActiveRecord::Migration
  def change
    create_table :facebook_adsets do |t|
      t.string :facebook_campaign_id
      t.string :facebook_id      
      t.string :name
      t.column :adlabels, :json
      t.column :adset_schedule, :json
      t.float :bid_amount
      t.float :daily_budget
      t.datetime :created_time
      t.datetime :updated_time
      t.datetime :start_time
      t.datetime :end_time
      t.string :optimization_goal
      t.string :status
      t.column :targeting, :json

      t.timestamps
    end
  end
end
