require 'csv'
namespace :users_migration do
  task :dump => :environment do
    filename = Rails.root.join('db/users.csv')
    CSV.open(filename, 'w') do |csv|
      Spree::User.find_each do |user|
        csv << [
          user.email, user.login, user.encrypted_password, user.password_salt,
          user.first_name, user.last_name, user.slug
        ]
      end
    end
  end
  task :migrate => :environment do
    filename = Rails.root.join('db/users.csv')
    CSV.open(filename, 'r').each_with_index do |row, i|
      puts row.inspect
      user = Spree::User.new
      user.email = row[0]
      user.login = row[1]
      user.encrypted_password = row[2]
      user.password_salt = row[3]
      user.first_name = row[4]
      user.last_name = row[5]
      user.slug = row[6]
      user.valid?
      errors = user.errors.messages
      errors.delete(:password)

      if errors.blank?
        user.save(validate: false)
        print "."
      else
        puts "** Can't create user with email: #{user.email}"
        puts "** Reason: #{errors}"
      end
      if i != 0 && i % 20 == 0
        puts "* Migrated 20 users"
      end
    end
  end
end