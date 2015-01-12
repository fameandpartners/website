## Welcome to FameAndPartners [ ![Status](https://circleci.com/gh/fameandpartners/website/tree/master.png?circle-token=ee3bbb5414da6e449d774074ecc31fec5a18dce0)](https://circleci.com/gh/fameandpartners/website)

### Development information
* We are using Spree Ecommerce as base engine.
[Guides](http://guides.spreecommerce.com)

### Getting started

* `$ git clone git@github.com:droidlabs/fame_and_partners.git`
* `$ cd ./fame_and_partners`
* `$ cp config/database.yml.example config/database.yml`

### Populating db with test data
Note: This commands can be run manullay or throught `bin/prepare_app`

* `$ bundle exec rake db:populate:dresses`
* `$ bundle exec rake db:populate:taxonomy`
* `$ bundle exec rake db:populate:product_options`
* `$ bundle exec rake db:populate:prototypes`

Note: it much easier to have working development application with loading database dump from production/preprod site, and restoring them locally. after it, remove valuable data & update settings
* delete users `Spree::User.delete_all`
* delete orders `Spree::Order.delete_all` 
* update shipping settings
* update payment method settings with test env
* if needed, update config/initializers/paperclip.rb && config/initializers/spree.rb configuration to use images from production. don't delete images locally it that case


### Update indexes
* for dresses list pages ( show product with different colours as different )
  `Products::ColorVariantsIndexer.index!`
* for search page ( show product only once )
  Tire.index(:spree_products) do
    delete
    import Spree::Product.all
  end
  Tire.index(:spree_products).refresh

## Manage colours pages
1) update "lib/tasks/populate/colors_groups.rake" file
2) deploy to production
3) connect to production via ssh
4) run rails console and delete existing option value groups using:
ruby
type = Spree::OptionType.find_by_name('dress-color')
Spree::OptionValuesGroup.where(option_type_id: type.id).destroy_all

5) exit from console end run Rake task "db:populate:colors_groups"

## Generate Shopping Feeds
* $ `ey ssh -e production_new`
* $ `cd /data/fame_and_partners/current`
* $ `bundle exec rake feed:export:all`


## Deploy

### Deploy to staging

Note: we are using CircleCi for master branch, manual deplyment usually not needed.

* $ `cap staging deploy`

### Deploy to production

* `$ gem install engineyard`
* merge master branch to production branch
* `$ ey deploy -e production_new`

### Thanks for using FameAndPartners!

Cheers, [Droid Labs](http://droidlabs.pro).


