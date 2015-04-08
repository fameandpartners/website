## Welcome to FameAndPartners [ ![Status](https://circleci.com/gh/fameandpartners/website/tree/master.png?circle-token=ee3bbb5414da6e449d774074ecc31fec5a18dce0)](https://circleci.com/gh/fameandpartners/website)

### Development information
* We are using Spree Ecommerce as base engine.
[Guides](http://guides.spreecommerce.com)

### Prerequisites

* Ruby 1.9.3-p547
* Postgres
* ElasticSearch
* Redis
* `imagemagick`
* [foreman](https://github.com/ddollar/foreman) - Development

#### Quick installation

```shell
$ brew install redis elasticsearch imagemagick postgresql
```

### Getting started

* `$ git clone git@github.com:fameandpartners/website.git`
* `$ cd ./website`
* `$ git submodule init && git submodule update` - to get the [styleguide](https://github.com/fameandpartners/styleguide)
* `$ cp config/database.yml.example config/database.yml`
* `$ bin/update_submodules` - For the common `styleguide` repository.

If you are using homebrew and it's default settings, the supplied Procfile may work out-of-the-box

```shell
$ foreman start
```

### Database

It is generally easiest to have working development application with loading database dump from production/preprod site, and restoring them locally.

* download latest dump from production ( through web interface from engine yard )
* clean database with `$bundle exec rake db:schema:load`
* restore data
  `pg_restore -d database_name --data-only --clean ./dump_file.dump`

after it, remove valuable data & update settings

* delete users `Spree::User.delete_all`
* delete orders `Spree::Order.delete_all`
* update shipping settings
* create user, and assign him admin rights `Spree::User.find(id).spree_roles << Spree::Role.find_by_name('admin')`
* update payment method settings with test env
* update facebook provider settings
* if needed, update config/initializers/paperclip.rb && config/initializers/spree.rb configuration to use images from production. don't delete images locally it that case
* refresh all local elastic search indexes

#### Update indexes

```ruby
Utility::Reindexer.reindex
```

For dresses list pages ( show product with different colours as different )

```ruby
Products::ColorVariantsIndexer.index!
```

For search page ( show product only once )

```ruby

Tire.index(configatron.elasticsearch.indices.spree_products) do
  delete
  import Spree::Product.all
end
Tire.index(configatron.elasticsearch.indices.spree_products).refresh
```

### Locating the Index Page
The index landing page can be found in the views/index/show.html

## Manage colours pages

1. update `lib/tasks/populate/colors_groups.rake` file
2. deploy to production
3. connect to production via ssh
4. run rails console and delete existing option value groups using:
    ```ruby
    type = Spree::OptionType.find_by_name('dress-color')
    Spree::OptionValuesGroup.where(option_type_id: type.id).destroy_all
    ```
5. exit from console end run Rake task "db:populate:colors_groups"

## Generate Shopping Feeds
* $ `ey ssh -e production_new`
* $ `cd /data/fame_and_partners/current`
* $ `bundle exec rake feed:export:all`

### Getting started


#### Populating db with test data
Note: This commands can be run manullay or throught `bin/prepare_app`

* `$ bundle exec rake db:populate:dresses`
* `$ bundle exec rake db:populate:taxonomy`
* `$ bundle exec rake db:populate:product_options`
* `$ bundle exec rake db:populate:prototypes`


## Deploy

Make sure your engine yard credentials are working

`$ gem install engineyard`


### Deploy to production

Merge master to production and push

* `$ git checkout production`
* `$ git merge master`
* `$ git git push`
* `$ ey deploy -e production_new --no-migrate`

To deploy with migrations (will turn maintenance mode on meaning site is down)
* `$ ey deploy -e production_new`


### Deploy to preproduction

Deploy any working branch to preprod

* `$ git checkout {branch}`
* `$ ey deploy -e preprod  --no-migrate`

To deploy with migrations (will turn maintenance mode on meaning site is down)
* `$ ey deploy -e preprod `


### Testing Payments

Access `/admin/payment_methods/1/edit`

 * `Active => Yes`
 * `Environment => Development`
 * `Test Mode => Checked`
 * `Server => test`

Test CC is `5520000000000000`

You can use any other details. 



## Useful Pages

 - **Home** - `IndexController#show`
 - **Category/Collection** - `Products::CollectionsController#show`
 - **Product** - `Products::DetailsController#show`


### Thanks for using FameAndPartners!

Cheers, [Droid Labs](http://droidlabs.pro).
