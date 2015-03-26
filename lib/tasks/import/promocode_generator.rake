namespace :promocode do
  desc 'delete known gone products'
  task :generate => :environment do
    puts Promotions::Generator.new.create(10)
  end
end
