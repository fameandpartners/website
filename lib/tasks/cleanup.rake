# encoding: utf-8

namespace :data do
  desc 'Cleans old and redundant information from the database'
  task :clean => :environment do
    # Spree::GarbageCleaner::Config.set(:cleanup_days_interval, 365)
    # Rake::Task["db:garbage:cleanup"].execute
        
    sql = [
      "DELETE FROM spree_orders WHERE completed_at IS NULL AND state = 'cart' AND created_at < '#{14.days.ago}'",
      "DELETE FROM spree_orders WHERE completed_at IS NULL AND state = 'address' AND created_at < '#{60.days.ago}'",
      "DELETE FROM activities WHERE created_at < '#{1.year.ago}'",
      "DELETE FROM spree_tokenized_permissions WHERE created_at < '#{7.days.ago}'",
    ]
    
    sql.each do |s|
      puts s
      ActiveRecord::Base.connection.execute(s)
    end
  end
end
