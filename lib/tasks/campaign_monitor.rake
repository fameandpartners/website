namespace :campaign_monitor do
  namespace :synchronize do
    desc 'Synchronize Campaign Monitor`s users list with system`s users list'
    task :users => :environment do
      Spree::User.all.each(&:synchronize_with_campaign_monitor!)
    end
  end
end
