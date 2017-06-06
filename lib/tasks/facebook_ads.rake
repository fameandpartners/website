require 'pathname'
require 'facebook/facebook_sync'

namespace :facebook_ads do
  namespace :campaigns do
    desc 'Update the list of facebook campaigns in the database'     
    task :sync => :environment do
      access_token = "EAAaDM5wsv7sBAG1cPMRDktA1O4yi9XFu7MvoEPqDuSNQljlaYIX829iCxmlPQAx0ao1vaY6dhZCZCUUakj9ES5MNt4uDu0rLzwJdj68YP003kf40sjtKMNTo5T4dDsZBOjxGLqZBMlDVb2DHcNFGxs9GGlMZASFQZD"
      sync = FacebookSync.new( access_token )

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
              end unless ad['insights'].nil?
              ad['adcreatives']['data'].each do |creative|
                FacebookAdCreative.update_from_json( ad_ar, creative )
              end unless ad['adcreatives'].nil?
            end unless adset['ads'].nil?
          end unless( campaign.nil? || campaign['adsets'].nil? )
        end if account['campaigns'] && account['campaigns']['data']
      end
    end
  end
end
