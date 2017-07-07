class AddActionsToFacebookInsights < ActiveRecord::Migration
  def change
    add_column :facebook_ad_insights, :actions, :json
    add_column :facebook_ad_insights, :action_values, :json
    
  end
end
