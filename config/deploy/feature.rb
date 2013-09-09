set :dns_name, "beta.23stages.com"

set :application, "fame-feature"
set :repository,  "git@github.com:fameandpartners/website.git"

role :web, dns_name                          # Your HTTP server, Apache/etc
role :app, dns_name                          # This may be the same as your `Web` server
role :db,  dns_name, primary: true           # This is where Rails migrations will run

set :deploy_to, "/data/#{application}"

set :rails_env, 'staging'
set :branch, 'feature'
set :use_sudo, false

set :user, 'ninja'
set :password, 'DC93zpfqgkekHw'
set :port, 22
set :db_username, "root"
