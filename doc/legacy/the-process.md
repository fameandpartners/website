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


## 
