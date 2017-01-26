# Wedding Atelier
## Usage:
First, make sure you have Postgres installed and running.
Then, run a series of database commands from APP root
```
script/db # Select option 2
bundle exec rake db:migrate wedding_atelier:populate_products
```

Then, if you are running this app as an Engine, you must activate it, run `rails console` and :
```
Features.activate(:wedding_atelier)
```
