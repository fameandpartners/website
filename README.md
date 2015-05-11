## Welcome to FameAndPartners [ ![Status](https://circleci.com/gh/fameandpartners/website/tree/master.png?circle-token=ee3bbb5414da6e449d774074ecc31fec5a18dce0)](https://circleci.com/gh/fameandpartners/website)

### IMPORTANT NOTE ON DEPLOYMENT

In general, we deploy fixes as we go.
However, any deployments requiring migration (see below) or that have any chance of directly impacting sales (changes to payment gateways, for example) should only occur within our Deployment Window.

The current deployment window is 18:00-20:00 AEST which is currently 04:00-06:00 EST and 01:00-03:00 PST.

As a general rule, feature flags should be used to control and test changes in the production environment before being flipped for general use.

Migrations that have been designed for zero-downtime deployment are excepted and can be deployed freely.



### Development information
* We are using Spree Ecommerce as base engine.
[Guides](http://guides.spreecommerce.com)

### Prerequisites

* Ruby 2.1.5 (2.2.0 also works)
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
* `$ cp config/database.yml.example config/database.yml`

If you are using homebrew and it's default settings, the supplied Procfile may work out-of-the-box

```shell
$ foreman start
```

It's also important to configure your Elasticsearch to enable dynamic scripting

```yaml
# Procfile assumes that this file is under /usr/local/opt/elasticsearch/config/elasticsearch.yml
script.disable_dynamic: false
```

### Database

It is generally easiest to have working development application with loading database dump from production/preprod site, and restoring them locally.

* download latest dump from production ( through web interface from engine yard )
* clean database with `$bundle exec rake db:schema:load`
* restore data
  `pg_restore -d fame_website_development --clean --if-exists --verbose --jobs 8 --no-acl --no-owner -U postgres`

after it, remove valuable data & update settings

* delete users `Spree::User.delete_all`
* delete orders `Spree::Order.delete_all`
* update shipping settings
* create user, and assign him admin rights `Spree::User.find(id).spree_roles << Spree::Role.find_by_name('admin')`
* update payment method settings with test env
* update facebook provider settings
* To view S3 images, set `config.use_s3 = true` in the `development.rb` file, without changing the `0_config.rb` file. Image uploads wont work, but for just viewing prod images, it’s perfect.
* refresh all local elastic search indexes

#### Sanitised Database

To remove almost everything **except** products and a few test users, you can instead run the following SQL,
this gets you a working site, with no customer data loaded.

```
delete from spree_users where email not like '%fameandpartners.com%';

truncate table activities;
truncate table blog_posts;
truncate table bridesmaid_party_events;
truncate table competition_entries;
truncate table competition_invitations;
truncate table email_notifications;
truncate table facebook_data;
truncate table line_item_personalizations;
truncate table marketing_user_visits;
truncate table product_accessories;
truncate table spree_addresses;
truncate table spree_adjustments;
truncate table spree_credit_cards;
truncate table spree_line_items;
truncate table spree_log_entries;
truncate table spree_orders;
truncate table spree_payments;
truncate table spree_paypal_express_checkouts;
truncate table spree_shipments;
truncate table spree_state_changes;
truncate table spree_tokenized_permissions;
truncate table spree_user_authentications;
truncate table user_style_profile_taxons;
truncate table user_style_profiles;
truncate table wishlist_items;
```

After Running this SQL you can capture the clean dump with a command like;

```
pg_dump --format=custom fame_website_development > ~/tmp/fame_website_development_clean.pgdump
```

After which you can restore it using;

```
pg_restore -d fame_website_development --clean --if-exists --verbose --jobs 8 --no-acl -U postgres ~/tmp/fame_website_development_clean.pgdump`
```


### Elasticsearch

#### Debugging requests

Set the `DEBUG_TIRE_REQUESTS` environment variable to enable verbose logging in development mode.

 ```shell
 $ export DEBUG_TIRE_REQUESTS=true
 ```

#### Update indexes

Re-index everything!

```ruby
rake elasticsearch:reindex
```

Or reindex using Rails console

```ruby
$ rails console
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

#### Caches

You can wipe local redis caches by running

```
rake cache:expire
```

#### Images & Assets

Images & assets by default in dev mode are served to you from the production S3 bucket.

If you wish to test or do image uploading, you will need to either switch to local mode, or switch to another S3 bucket.
By default the AWS access credentials are not loaded in dev mode, so these features will fail.

`config/environments/development.rb`

```
# Use S3 for storing attachments
config.use_s3 = true # Change to false for local
```

Or set new AWS credentials in for `:development` mode in `config/initializers/0_config.rb`

#### BIG RED BUTTON

The nuclear approach can get your environment (elasticsearch, redis, assets) to a clean slate by running the command;

```
rake dev:clean_slate
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


### Testing Orders & Payments

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
