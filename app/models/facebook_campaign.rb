class FacebookCampaign < ActiveRecord::Base
  attr_accessible :created_time, :facebook_account_id, :name, :recommendations, :start_time, :status, :stop_time, :updated_time, :facebook_id

  def self.update_from_json( account, campaign_json )
    campaign = FacebookCampaign.find_or_create_by_facebook_id( facebook_id: campaign_json['id'] )
    campaign.update_attributes(created_time: campaign_json['created_time'], facebook_account_id: account.id, name: campaign_json['name'], recommendations: campaign_json['recommendations'], start_time: campaign_json['start_time'], status: campaign_json['status'], stop_time: campaign_json['stop_time'], updated_time: campaign_json['updated_time'], facebook_id: campaign_json['id'] )
    campaign
  end
  
end
