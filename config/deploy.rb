require 'capistrano/ext/multistage'
require 'bundler/capistrano'
require 'capistrano-rbenv'

set :stages, %w(staging feature)
set :default_stage, "staging"
set :deploy_via, :remote_cache
set :keep_releases, 5
set :scm, :git

before  'deploy:setup', 'db:create_config'
after   'deploy:setup', 'deploy:first'

after   'deploy:update_code', 'db:create_symlink'
after   'deploy:update_code', 'cron:update'
after   'deploy:create_symlink', 'deploy:cleanup'
after   'deploy:finalize_update', 'rbenv:create_version_file'

# resque
# after   'deploy:restart', 'resque:restart'
# after   'deploy:restart', 'resque_scheduler:restart'
