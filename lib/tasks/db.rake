namespace :db do

  desc 'Reset PostgreSQL Sequences - Useful after database restores'
  task :reset_sequences => :environment do
    puts "Resetting PK Sequences"
    ActiveRecord::Base.connection.tables.each do |t|
      puts "Table: #{t}"
      ActiveRecord::Base.connection.reset_pk_sequence!(t)
    end
  end

end
