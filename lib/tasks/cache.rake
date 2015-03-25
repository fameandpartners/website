namespace :cache do
  desc 'Clear the rails cache'
  task :clear => :environment do
    puts Rails.cache.clear
  end

  desc 'Clear the rails cache'
  task :expire => :clear
end
