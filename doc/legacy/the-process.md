## Legacy Process

**NOTE :: This section is preserved for posterity**

> It is generally easiest to have working development application with loading database dump from production/preprod site, and restoring them locally.

> * download latest dump from production ( through web interface from engine yard )
> * clean database with `$bundle exec rake db:schema:load`
> * restore data
  `pg_restore -d fame_website_development --clean --if-exists --verbose --jobs 8 --no-acl --no-owner -U postgres`

> after it, remove valuable data & update settings

> * delete users `Spree::User.delete_all`
> * delete orders `Spree::Order.delete_all`
> * update shipping settings
> * create user, and assign him admin rights `Spree::User.find(id).spree_roles << Spree::Role.find_by_name('admin')`
> * update payment method settings with test env
> * update facebook provider settings
> * To view S3 images, set `config.use_s3 = true` in the `development.rb` file, without changing the `0_config.rb` file. Image uploads wont work, but for just viewing prod images, it’s perfect.
> * refresh all local elastic search indexes


## Old legacy process rake task 
 
```ruby
# /doc/legacy/the-process.md
namespace :dev do
  desc 'Get a completely clean slate, no cache, no assets, no images, no elasticsearch index.'
  task :clean_slate => ["assets:clean", "cache:expire", "elasticsearch:reindex"]

  def message(str = nil)
    puts '-' * 72
    print Time.now.strftime('[%H:%M:%S] ')
    puts str
  end

  task :only_in_dev => :environment  do
    abort("Can only run on development") unless Rails.env.development?
  end

  desc 'Reload dev from production database'
  task :reload_from_production => [:load_from_production, :sanitize_production_data]

  task :load_from_production do

    database_name = Rails.configuration.database_configuration['development']["database"]

    database_backups = FileList.new('tmp/database_backups/*.dump')
    backup_to_restore = File.join Rails.root, database_backups.first

    abort("Missing file #{backup_to_restore}") unless File.exist? backup_to_restore
    abort("Unknown database #{database_name}") unless database_name.present?

    message "Restoring dump: #{backup_to_restore} into the database: #{database_name}"

    message "Terminate connections..."
    `psql -U postgres $DB_TO -t -c  "SELECT pid, pg_terminate_backend(pid) AS terminated  FROM pg_stat_activity  WHERE pid <> pg_backend_pid() AND datname = '$DB_TO';"`
    message "Drop DB"
    `dropdb -U postgres #{database_name}`
    message "Create DB"
    `createdb -U postgres #{database_name}`
    message "Restore DB"
    `pg_restore --dbname #{database_name} --no-acl --no-owner --clean #{backup_to_restore}`

  end
  task :sanitize_production_data => :only_in_dev do

    message "Deleting users"
    message Spree::User.delete_all

    message "Deleting orders"
    message Spree::Order.delete_all


    message "Creating new user (dev-admin@fameandpartners.com)"
    admin_user = Spree::User.create_user(first_name: 'Dev',
                                         last_name: 'Admin',
                                         email: 'dev-admin@fameandpartners.com',
                                         password: 'password')
    admin_user.spree_roles << Spree::Role.find_by_name('admin')
    admin_user.save!

    message "Reindexing"
    Utility::Reindexer.reindex

    message "Manual Steps Remaining"
    puts "* update payment method settings with test env"
    puts "* update facebook provider settings"
    puts "* if needed, update config/initializers/paperclip.rb && config/initializers/spree.rb configuration to use images from production. don't delete images locally it that case"
  end
end
```
