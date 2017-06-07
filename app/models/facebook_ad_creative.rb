class FacebookAdCreative < ActiveRecord::Base
  attr_accessible :facebook_ad_id, :image_url, :facebook_id

  def self.update_from_json( ad, creative_json )
    if( creative_json['image_url'] )
      creative = FacebookAdCreative.find( :first, conditions: {facebook_ad_id: ad.id, image_url: creative_json['image_url']} )
      creative = FacebookAdCreative.create( facebook_ad_id: ad.id,
                                           image_url: creative_json['image_url'],
                                           facebook_id: creative_json['id'] ) if creative.nil?
      creative
    else
      nil
    end
                                        
  end
  
end
