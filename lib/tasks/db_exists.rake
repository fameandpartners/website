namespace :db do
  desc "Checks to see if the database exists"
  task :exists do
    begin
      Rake::Task['environment'].invoke
      ActiveRecord::Base.connection
    rescue
      puts "1"
      exit 1
    else
      puts "0"
      exit 0
    end
  end
end
