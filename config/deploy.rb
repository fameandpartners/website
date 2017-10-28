# require 'capistrano/ext/multistage'
# require 'bundler/capistrano'
# require 'sidekiq/capistrano'

# set :default_environment, {
#   'PATH' => "/usr/local/rbenv/shims:/usr/local/rbenv/bin:$PATH"
# }

# set :stages, %w(staging feature)
# set :default_stage, "staging"
# set :deploy_via, :remote_cache
# set :keep_releases, 5
# set :scm, :git
# set :shared_children, shared_children + %w{public/spree}

# before  'bundle:install',  'rbenv:create_version_file'

# after   'deploy:update_code', 'db:create_symlink'
# after   'deploy:update_code', 'cron:update'
# after   'deploy:create_symlink', 'deploy:cleanup'
