class FacebookAd < ActiveRecord::Base
  attr_accessible :bid_amount, :created_time, :facebook_adset_id, :facebook_id, :name, :recommendations, :status, :updated_time

  def self.update_from_json( adset, ad_json )
    ad = FacebookAd.find_or_create_by_facebook_id( facebook_id: ad_json['id'] )
    ad.update_attributes(created_time: ad_json['created_time'], facebook_adset_id: adset.id, bid_amount: ad_json['bid_amount'], facebook_id: ad_json['id'], name: ad_json['name'] , recommendations: ad_json['recommendations']&.to_json , status: ad_json['status'] , updated_time: ad_json['updated_time']  )
    ad
  end
  
end
