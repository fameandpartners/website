source 'https://rubygems.org'

ruby '2.3.3'

gem 'rails', '~> 3.2.22.5'
gem 'test-unit' # test-unit is required by Rails 3, and Ruby 2.3 is harsher on dependency requirements
gem 'pg'
gem 'slim'
gem 'slim-rails'
gem 'configatron'
gem 'paperclip'
gem 'sidekiq', '4.2.2'
gem 'whenever'
gem 'psych', '~> 2.1.0'
gem 'active_model_serializers'
gem 'rack-cors'
gem 'business_time'
gem 'rmagick'
gem 'default_value_for'
gem 'dalli'
gem 'autoprefixer-rails'
gem 'elasticsearch-dsl'
gem 'elasticsearch'
gem 'net-ssh'
gem 'activerecord-postgres-json'
gem 'rake', '< 12.0'

# Monitoring & Events
gem 'newrelic_rpm'
gem 'sentry-raven'
gem 'customerio', '~> 1.0.0'

# Engines
path 'engines' do
  gem 'admin_ui'
  gem 'fame_favicon'
  gem 'inspinia-rails'
  gem 'bergen'
  gem 'manual_order'
  gem 'afterpay'
  gem 'next_logistics'
  gem 'bronto'
end

# TODO : I shouldn't actually need this here as `admin_ui` explicitly requires it,
# but it wont be available as a helper method unless it's included in the main app.
gem 'active_link_to'
gem 'simple_form'

# assets
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'jquery-fileupload-rails', '0.4.1'
gem 'sass-rails',   '~> 3.2.3'
gem 'asset_sync', '~> 2.0'
gem 'fog-aws', '~> 1.2.0'
gem 'rack-proxy'

# Data
gem 'event_sourced_record'
gem 'coercible'
gem 'reform', '~> 2.0.5'

gem 'ipaddress'
gem 'geoip', require: false
gem 'device_detector', '~> 0.8.1'
gem 'rubyzip', '~> 1.1.7', require: false
gem 'roo', require: false
gem 'koala'

gem 'google_drive', '1.0.0', require: false # parse spread sheet

gem 'sitemap_generator'

gem 'canonical-rails', github: 'jumph4x/canonical-rails'

gem 'spree', :github => 'spree/spree', :branch => '1-3-stable'

#payments
gem 'pin_payment'
gem 'stripe', :git => 'https://github.com/stripe/stripe-ruby'

# spree extensions for authentication
gem 'spree_auth_devise',
    :github => 'spree/spree_auth_devise',
    :branch => '1-3-stable',
    :ref => 'c4466de3748618971dc401e6e30c0d87f2b9c143'

gem 'spree_social', :github => 'spree/spree_social', :branch => '1-3-stable'


# spree extensions for payments
gem 'spree_gateway', :github => 'spree/spree_gateway', :branch => '1-3-stable'
gem 'spree_paypal_express', github: 'fameandpartners/better_spree_paypal_express', branch: '1-3-stable'

gem 'spree_essentials', :git => 'git://github.com/bbtfr/spree_essentials.git', :branch => '1.3.x'

# utils

gem 'json'
gem 'net-sftp'
# replacement for standard library.
gem 'addressable'

gem 'rollout'

# masterpass gateway
gem 'spree_masterpass', :path => './spree_masterpass'

# Command line tools
gem 'term-ansicolor',   :require => false
gem 'ruby-progressbar', :require => false

gem 'ops_care', :git => 'git@github.com:reinteractive/OpsCare.git', :branch => 'master'

gem 'unicorn'

group :assets do
  gem 'coffee-rails', '~> 3.2.1'
  gem 'coffee-script-source', '~> 1.8.0'
  gem 'uglifier', '1.3.0'
  gem 'execjs', '~> 2'
  gem 'eco'
end

group :development do
  gem 'foreman', require: false
  gem 'better_errors'
  gem 'awesome_print', require: "ap"
  gem 'letter_opener', '~> 1.4.1'
  gem 'quiet_assets'
  gem 'bullet'
  gem 'binding_of_caller'
  gem 'rack-handlers'
end

group :test do
  gem 'rspec-rails', '~> 3.2'
  gem 'capybara', '~> 2.11.0'
  gem 'capybara-screenshot', '~> 1.0.11'
  gem 'poltergeist', '~> 1.12.0'
  gem 'selenium-webdriver', '~> 2.53.4'
  gem 'show_me_the_cookies', '~> 3.1.0'
  gem 'turnip', '~> 1.3.1'
  gem 'factory_girl_rails', '4.2.1'
  gem 'rspec-activemodel-mocks'
  gem 'rspec-collection_matchers'
  gem 'rspec-retry'
  gem 'database_cleaner'
  gem 'shoulda-matchers'
  gem 'timecop'
  gem 'vcr', '~> 2.9.3'
  gem 'webmock', '~> 1.21.0'
  gem 'rspec_junit_formatter', '0.2.2'
  gem 'rspec-shell-expectations'
end

group :development, :test do
  gem 'pry-byebug'
end