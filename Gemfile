source 'https://rubygems.org'

gem 'rails', :github => 'rails/rails', :branch => '3-2-stable'
gem 'pg'
gem 'slim'
gem 'slim-rails'
gem 'configatron'
gem 'paperclip'
gem 'createsend', '~> 2.5.0'
gem 'sidekiq', '2.13.0'
gem 'timers', '1.1.0'
gem 'whenever'
gem 'psych', '~> 2.0.13'
gem 'active_model_serializers'
gem 'data_migrate', git: 'git://github.com/droidlabs/data-migrate.git'
gem 'rack-cors'
gem 'business_time'
gem 'acts-as-taggable-on'
gem 'rmagick'
gem 'ckeditor'
gem 'default_value_for'
gem 'tire'
gem 'redis-rails'
gem 'titleize'
gem 'autoprefixer-rails'

# Monitoring & Events
gem 'newrelic_rpm'
gem 'customerio'

# Engines
path 'engines' do
  gem 'revolution'
  gem 'admin_ui'
  gem 'fame_favicon'
  gem 'inspinia-rails'
end

# TODO : I shouldn't actually need this here as `admin_ui` explicitly requires it,
# but it wont be available as a helper method unless it's included in the main app.
gem 'active_link_to'

# assets
gem 'jquery-rails'
gem 'sass-rails',   '~> 3.2.3'
gem 'droidcss'

# Data
gem 'event_sourced_record'
gem 'coercible'

gem 'ipaddress'
gem 'geoip', require: false
gem 'rubyzip', '< 0.9.9', require: false
gem 'roo', require: false

gem 'twitter'
gem 'instagram'
gem 'google_drive', '1.0.0', require: false # parse spread sheet

gem 'sitemap_generator'
gem 'fog'

gem 'canonical-rails', github: 'jumph4x/canonical-rails'

gem 'pry-rails'

gem 'spree', :github => 'spree/spree', :branch => '1-3-stable'
gem 'spree_banner', '~> 1.3.0'


# spree extensions for authentication
gem 'spree_auth_devise',
  :github => 'spree/spree_auth_devise',
  :branch => '1-3-stable',
  :ref => 'c4466de3748618971dc401e6e30c0d87f2b9c143'

gem 'spree_social', :github => 'spree/spree_social', :branch => '1-3-stable'


# spree extensions for payments
gem 'spree_gateway', :github => 'spree/spree_gateway', :branch => '1-3-stable'
gem 'spree_paypal_express',
  github: 'evgeniypetrov/better_spree_paypal_express',
  branch: '1-3-stable',
  ref: '478b27281f7ed806df5ae86a41f9890595f8d242'

gem 'spree_essentials', :git => 'git://github.com/bbtfr/spree_essentials.git', :branch => '1.3.x'

# utils
# replacement for standard library.
gem 'addressable', require: false

gem 'rollout'

# Command line tools
gem 'term-ansicolor',   :require => false
gem 'ruby-progressbar', :require => false

gem 'sinatra',          :require => false

group :assets do
  gem 'bourbon'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'coffee-script-source', "~> 1.8.0"
  gem 'uglifier', '1.3.0'
  gem 'execjs', '1.4.0'
  gem 'jquery-ui-rails'
  gem 'jquery-fileupload-rails', '0.4.1'
  gem 'eco'
  gem 'bootstrap-sass'
end

group :assets, :development, :test do
  gem 'test-unit'  
end

group :development, :test do
  gem 'awesome_print'
  gem 'capistrano', '2.15.4', require: false
  gem 'capistrano-rbenv', '0.0.10', require: false
  gem 'capybara'
  gem 'compass'
  gem 'database_cleaner', '0.9.1'
  gem 'factory_girl_rails', '4.2.1'
  gem 'launchy', '2.2.0'
  gem 'letter_opener', '0.0.2', git: 'git://github.com/droidlabs/letter_opener.git'
  gem 'mail_view', :git => 'https://github.com/37signals/mail_view.git'
  # gem 'minitest'
  gem 'net-ssh', '~> 2.7.0'
  gem 'oink'
  gem 'pry-byebug'
  gem 'quiet_assets'
  gem 'rspec-activemodel-mocks'
  gem 'rspec-collection_matchers'
  gem 'rspec-rails', '~> 3.2'
  gem 'shoulda-matchers'
  gem 'spring'
  gem 'thin'
end

group :test do
  gem 'capybara-screenshot'
  gem 'ffaker'
  gem 'poltergeist'
  gem 'selenium-webdriver'
  gem 'turnip'
end

group :staging, :development do
  gem 'libv8', '~> 3.16'
  gem 'therubyracer'
end

group :production do
  gem 'unicorn'
  gem 'aws-sdk'
end
