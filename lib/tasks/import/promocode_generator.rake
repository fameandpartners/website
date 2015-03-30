namespace :promocode do
  desc 'delete known gone products'
  task :generate => :environment do
    count = ENV['COUNT'] || 1
    puts Promotions::Generator.new.create(count)
  end
end
