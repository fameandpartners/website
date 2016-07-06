# Welcome to Fame & Partners [![Status](https://circleci.com/gh/fameandpartners/website/tree/master.png?circle-token=ee3bbb5414da6e449d774074ecc31fec5a18dce0)](https://circleci.com/gh/fameandpartners/website)

## System Requirements

* Ruby 2.1.5 (2.2.0 also works)
* Postgres 9.2
* ElasticSearch 1.6.0
* Redis 3.0.2
* `imagemagick` 6.9.1

> Libraries versions can vary. Versions used above are suggestions.

For more details on installing each library, check [doc/dev/libraries-setup.md](doc/dev/libraries-setup.md).

### Coding Style

* We use [EditorConfig](http://EditorConfig.org) to keep coding styles. Please, if you use any text editors/IDEs that don't support it out of the box, [download a plugin for it](http://editorconfig.org/#download).
* Remember, follow *THE RULES*, otherwise, your PR will receive complaints: https://github.com/fameandpartners/website/wiki/The-Rules
* Front-end:
  * CSS guidelines: https://github.com/fameandpartners/website/blob/master/doc/dev/css-guidelines.md
  * JS guidelines: https://github.com/fameandpartners/website/wiki/JS-Guidelines

### Frameworks

* We are using Spree Ecommerce base engine. See more details at the [Spree Guides website.](http://guides.spreecommerce.com)

### Getting started

* `$ git clone git@github.com:fameandpartners/website.git`
* `$ cd ./website`
* `$ cp config/database.yml.example config/database.yml`

If you are using homebrew and it's default settings, the supplied Procfile may work out-of-the-box

```shell
$ bundle exec thin start -p 3000
```

It's also important to configure your Elasticsearch to enable dynamic scripting

```yaml
# Procfile assumes that this file is under /usr/local/opt/elasticsearch/config/elasticsearch.yml
script.disable_dynamic: false
```

## Environment Variables

Running the app in development mode requires the presence of the `.env` file in the apps root folder.

This file loads environment variables required to run the application. You can use the `.env.example` file, which contains examples of the actual values that are used on production.

## Vendored Gems

All gems are vendored (downloaded and stored at `vendor/cache`). Because of this `bundle/config` file is now versioned. Be careful to **NOT** change it.

### Creating an Admin User

Steps to create an admin user:

* If you do not already have an existing user in mind, create one through the existing web site process.
* To assign admin rights in the Rails console, first find the user: `Spree::User.where(email: 'user@email').first`
* Then using the id of the user found: `Spree::User.find(id).spree_roles << Spree::Role.find_by_name('admin')`

## Documentation

Documentation can be found in [the wiki](https://github.com/fameandpartners/website/wiki/) and in `/doc` folder, located on the root of this project.

## Database

### Local Database

There is a script to automate a few local database tasks.

See `./script/db`

```
 ./script/db
 >> FAME - Fully Awesome Menu Engine
 1) load_production_db        Restore the most recent production        backup file to development
 2) load_development_db       Restore the most recent development       backup file to development
 3) restore_env_menu          Restore the most recent any environment's backup file to development
 4) restore_file_menu         Restore any selected                      backup file to development
 5) dump_production_db        Backup production        database to a file
 6) dump_development_db       Backup development       database to a file
 7) dump_menu                 Backup any environment's database to a file
 8) sanitise_dev_db           Delete sensitive information from development db. Also shrinks size massively
 >> Select a command to run or Control+C to cancel:
```

It allows you to backup local development databases, and restore backups from local copies of production.

Note that you will still need to manually download production backups right now. The script will prompt you on how to do it.

### Sanitised Database

To remove almost everything **except** products and a few test users, you can run the following command,
this gets you a working site, with no customer data.

Run `./script/db` and Choose 8 `sanitise_dev_db` to clean the current dev DB.
See the source to see exactly what is removed.

### EngineYard Databases

**For more information on EngineYard database management, see**
[How To Backup/Restore Engine Yard Databases](doc/ops/howto-backup-restore-engineyard-databases.md).

## Elasticsearch

### Debugging requests

Set the `DEBUG_TIRE_REQUESTS` environment variable to enable verbose logging in development mode.

```shell
$ export DEBUG_TIRE_REQUESTS=true
```

### Update indexes

Re-index everything!

```ruby
rake elasticsearch:reindex
```

Or reindex using Rails console

```ruby
$ rails console
Utility::Reindexer.reindex
```

For dresses list pages (show product with different colours as different)

```ruby
Products::ColorVariantsIndexer.index!
```

For search page (show product only once)

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
By default the AWS access credentials are *not loaded in dev mode*, so these features will fail.

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

## Content / Quality Issues

[Dealing with Content Quality Issues (doc/content_quality.md) ](doc/content_quality.md)

## Deployment

For more information, please refer to the [deployment docs](doc/ops/deployment.md).

### Testing Orders & Payments

Access `/admin/payment_methods/1/edit`

 * `Active => Yes`
 * `Environment => Development`
 * `Test Mode => Checked`
 * `Server => test`

Test CC is `5520000000000000`

You can use any other details.

## Testing

To run every test, including engines', use the `bundle exec rake spec engines` command

## Useful Pages

 - **Home** - `IndexController#show`
 - **Category/Collection** - `Products::CollectionsController#show`
 - **Product** - `Products::DetailsController#show`

Cheers,
Fame & Partners and Unicorns!
