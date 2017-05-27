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
        account['campaigns']['data'].each do |campaign|
          puts "#{campaign['name']}"
          campaign['adsets']['data'].each do |adset|
            puts "\t#{adset['name']} has #{adset['ads']['data'].count} ads" unless adset['ads'].nil?
          end unless( campaign.nil? || campaign['adsets'].nil? )
        end if account['campaigns'] && account['campaigns']['data']
      end
    end
  end
end
