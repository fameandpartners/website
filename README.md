## Welcome to FameAndPartners [ ![Status](https://circleci.com/gh/fameandpartners/website/tree/master.png?circle-token=ee3bbb5414da6e449d774074ecc31fec5a18dce0)](https://circleci.com/gh/fameandpartners/website)


### Getting started

* `$ git clone git@github.com:droidlabs/fame_and_partners.git`
* `$ cd ./fame_and_partners`
* `$ cp config/database.yml.example config/database.yml`
* `$ bin/prepare_app`


#### Fig & Docker

The easiest way to setup the local environment is with fig and docker. 

Assuming OSX

- install virtual box
- install boot2docker `brew install boot2docker`
- install fig `brew install fig`
- install postgres `brew install postgres`
- clone the app `git clone git@github.com:droidlabs/fame_and_partners.git`
- `cd ./fame_and_partners`
- set database.yml credentials - host should be the same, but see below
- `fig up -d db`
- `fig up -d redis`
- `fig web run bin/prepare_app`

Notes:
If the database can't be found, you can find the host ip by logging into the boot2docker vm and determining where you logged in from using the last command

- `boot2docker ssh`
- `last` 
- amend database.yml with the correct ip address.






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


