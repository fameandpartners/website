namespace :assets do
  desc 'Bundles production JS executing `npm install` and `npm run production` commands'
  task :bundle_js do
    %x(npm install --only=prod && npm run production)
  end
end

Rake::Task['assets:precompile'].enhance ['assets:bundle_js']
