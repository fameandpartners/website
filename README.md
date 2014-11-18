## Welcome to FameAndPartners [ ![Status](https://circleci.com/gh/fameandpartners/website/tree/master.png?circle-token=ee3bbb5414da6e449d774074ecc31fec5a18dce0)](https://circleci.com/gh/fameandpartners/website)

### Getting started

* `$ git clone git@github.com:droidlabs/fame_and_partners.git`
* `$ cd ./fame_and_partners`
* `$ cp config/database.yml.example config/database.yml`
* `$ bin/prepare_app`

### Development information

* We are using Spree Ecommerce as base engine.
[Guides](http://guides.spreecommerce.com)

### Populating db with test data

Note: these commands not needed after bin/prepare_app

* `$ bundle exec rake db:populate:dresses`
* `$ bundle exec rake db:populate:taxonomy`
* `$ bundle exec rake db:populate:product_options`
* `$ bundle exec rake db:populate:prototypes`

### Update indexes
Tire.index(:spree_products) do
  delete
  import Spree::Product.all
end

## Manage colous pages
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


