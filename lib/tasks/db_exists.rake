namespace :db do
  desc "Checks to see if the database exists"
  task :exists do
    begin
      Rake::Task['environment'].invoke
      ActiveRecord::Base.connection
    rescue
      puts "Database does not exist"
      exit 1
    else
      puts "Database exists"
      exit 0
    end
  end
end
