namespace :promocode do
  desc 'delete known gone products'
  task :generate => :environment do
    count   = ENV['COUNT'] || 1
    prefix  = ENV['PREFIX'] || 'fame'
    type    = ENV['TYPE'] || 'alpha'
    start   = ENV['START'] || 0

    if type == 'numeric'
      puts Promotions::Generator.new.create_numeric(count, start, prefix)
    else
      puts Promotions::Generator.new.create(count, prefix)
    end
  end
end
