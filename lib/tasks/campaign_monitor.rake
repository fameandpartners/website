#
# bundle exec rake campaign_monitor:synchronize:users
#
namespace :campaign_monitor do
  namespace :synchronize do
    desc 'Synchronize Campaign Monitor`s users list with system`s users list'
    task :users => :environment do
      Spree::User.find_in_batches(batch_size: 10) do |batch|
        batch.each do |user|
          Marketing::Subscriber.new(user: user).update
        end
      end
    end
  end
end
