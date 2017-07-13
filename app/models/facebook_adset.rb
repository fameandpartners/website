class FacebookAdset < ActiveRecord::Base
  attr_accessible :adlabels, :adset_schedule, :bid_amount, :created_time, :daily_budget, :end_time, :name, :optimization_goal, :start_time, :status, :targeting, :updated_time, :facebook_id, :facebook_campaign_id

  def self.update_from_json( campaign, adset_json )
    adset = FacebookAdset.find_or_create_by_facebook_id( facebook_id: adset_json['id'] )
    adset.update_attributes( facebook_campaign_id: campaign.id,
                             adlabels: adset_json['adlabels'],
                             adset_schedule: adset_json['adset_schedule'],
                             bid_amount: adset_json['bid_amount'],
                             created_time: adset_json['created_time'],
                             daily_budget: adset_json['daily_budget'],
                             end_time: adset_json['end_time'],
                             name: adset_json['name'],
                             optimization_goal: adset_json['optimization_goal'],
                             start_time: adset_json['start_time'],
                             status: adset_json['status'],
                             targeting: adset_json['targeting']&.to_json,
                             updated_time: adset_json['updated_time'],
                             facebook_id: adset_json['id'])
    
    adset
  end
  
end
