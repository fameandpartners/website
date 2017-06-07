require 'pathname'

namespace :facebook_ads do
  desc 'Update the list of facebook campaigns in the database'     
  task :sync => :environment do
    Facebook::FacebookSync.sync_last_28_days
  end
end
