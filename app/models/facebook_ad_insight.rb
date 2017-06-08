class FacebookAdInsight < ActiveRecord::Base
  attr_accessible :clicks, :cost_per_action_type, :cpc, :cpm, :cpp, :ctr, :date_start, :date_stop, :facebook_ad_id,  :frequency, :reach, :relevance_score, :social_impressions, :spend, :total_actions, :total_unique_actions, :website_clicks, :website_ctr, :actions, :action_values

  belongs_to :facebook_ad
  
  def self.update_from_json( ad, insight_json )
    insight = FacebookAdInsight.find( :first, conditions: {facebook_ad_id: ad.id,  date_start: Time.zone.parse( insight_json['date_start'] ), date_stop: Time.zone.parse( insight_json['date_stop'] ) } )
    insight = FacebookAdInsight.create( facebook_ad_id: ad.id,  date_start: insight_json['date_start'], date_stop: insight_json['date_stop'] ) if insight.nil?
    insight.update_attributes(  clicks: insight_json['clicks'],
                         cost_per_action_type: insight_json['cost_per_action_type'],
                         cpc: insight_json['cpc'],
                         cpm: insight_json['cpm'],
                         cpp: insight_json['cpp'],
                         ctr: insight_json['ctr'],
                         date_start: insight_json['date_start'],
                         date_stop: insight_json['date_stop'],
                         frequency: insight_json['frequency'],
                         reach: insight_json['reach'],
                         relevance_score: insight_json['relevance_score']&.to_json,
                         social_impressions: insight_json['social_impressions']&.to_json,
                         spend: insight_json['spend'],
                         total_actions: insight_json['total_actions'],
                         total_unique_actions: insight_json['total_unique_actions'],
                         website_clicks: insight_json['website_clicks'],
                         website_ctr: insight_json['website_ctr']&.to_json,
                         actions: insight_json['actions']&.to_json,
                         action_values: insight_json['action_values']&.to_json )
    insight
  end
  
end
