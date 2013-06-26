## Welcome to Fame and Partners

### Setup project
```
$ git clone git@github.com:droidlabs/fame_and_partners.git
$ cd ./fame_and_partners
$ cp config/database.yml.example config/database.yml
$ bundle install
```

### Setup database
```
$ rake db:setup
$ rake spree_sample:load
```

### Development information
* We are using Spree Ecommerce as base engine.
[Guides](http://guides.spreecommerce.com)

### Populating db with test data
```
$ bundle exec rake db:populate:dresses
$ bundle exec rake db:populate:taxonomy
$ bundle exec rake db:populate:product_options
```

### Thanks for using Fame and Partners!

Cheers, [Droid Labs](http://droidlabs.pro).


