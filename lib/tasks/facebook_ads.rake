require 'pathname'
require 'facebook/facebook_sync'

namespace :facebook_ads do
  desc 'Update the list of facebook campaigns in the database'     
  task :sync => :environment do
    access_token = ENV['FACEBOOK_SYNC_ACCESS_KEY']
    
    (0..28).each do |days_back|
      puts "Working on day #{days_back.days.ago.to_date.to_s}"
      sync = FacebookSync.new( access_token, days_back.days.ago.to_date )
      while( sync.has_more_pages? ) do
        account = sync.next_page
        active_record_account = FacebookAccount.update_from_json( account )        
        account['campaigns']['data'].each do |campaign|
          campaign_ar = FacebookCampaign.update_from_json( active_record_account, campaign )
          campaign['adsets']['data'].each do |adset|
            adset_ar = FacebookAdset.update_from_json( campaign_ar, adset )
            adset['ads']['data'].each do|ad|
              ad_ar = FacebookAd.update_from_json( adset_ar, ad )
              ad['insights']['data'].each do|insight|
                insight_ar = FacebookAdInsight.update_from_json( ad_ar, insight )
              end if ad['insights'].present?
              ad['adcreatives']['data'].each do |creative|
                FacebookAdCreative.update_from_json( ad_ar, creative )
              end if ad['adcreatives'].present?
            end if adset['ads'].present?
          end if( campaign.present? && campaign['adsets'].present? )
        end if account['campaigns'] && account['campaigns']['data']
      end
    end
  end
end
