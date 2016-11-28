# NOTE: JS bundling at the `before_assets.sh` deployment hook
namespace :assets do
  desc 'Bundles production JS executing `yarn install` and `yarn run prod` commands'
  task :bundle_js do
    %x(yarn install && yarn run prod)
  end
end

Rake::Task['assets:precompile'].enhance ['assets:bundle_js']
