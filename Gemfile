source 'https://rubygems.org'

ruby '2.1.6'

gem 'rails', '~> 4.2.6'
gem 'pg'
gem 'slim'
gem 'slim-rails'
gem 'configatron'
gem 'paperclip'
gem 'sidekiq', '2.13.0'
gem 'timers', '~> 4.0.0'
gem 'whenever'
gem 'psych', '~> 2.0.13'
gem 'active_model_serializers'
gem 'rack-cors'
gem 'business_time'
gem 'rmagick'
gem 'ckeditor'
gem 'default_value_for'
gem 'tire'
gem 'redis-rails'
gem 'autoprefixer-rails'
# UPDATED
gem 'bower-rails', '~> 0.10.0'
gem 'redcarpet', '~> 2.3.0'

# Monitoring & Events
gem 'newrelic_rpm'
gem 'sentry-raven'
gem 'customerio', '~> 1.0.0'

# Engines
path 'engines' do
  gem 'revolution'
  gem 'admin_ui'
  gem 'fame_favicon'
  gem 'inspinia-rails'
  gem 'bergen'
  gem 'manual_order'
end

# TODO : I shouldn't actually need this here as `admin_ui` explicitly requires it,
# but it wont be available as a helper method unless it's included in the main app.
gem 'active_link_to'
gem 'simple_form'

# assets
gem 'jquery-rails'
gem 'jquery-ui-rails'
gem 'jquery-fileupload-rails', '0.4.1'
gem 'sass-rails',   '~> 5.0.4'
gem 'compass-rails', '~> 2.0.5'
gem 'react-rails', '~> 1.6'
gem 'droidcss', '~> 2.0.4'

# Data
gem 'event_sourced_record'
gem 'coercible'

gem 'ipaddress'
gem 'geoip', require: false
gem 'device_detector', '~> 0.8.1'
gem 'rubyzip', '~> 1.1.7', require: false
gem 'roo', require: false

gem 'google_drive', '1.0.0', require: false # parse spread sheet
gem 'google-api-client', '~> 0.8.6'

gem 'sitemap_generator'
gem 'fog'

gem 'canonical-rails', path: '../gems/canonical-rails'

gem 'spree', path: '../gems/spree'
gem 'spree_banner', '~> 1.3.0'

#payments
gem 'pin_payment'

# spree extensions for authentication
gem 'spree_auth_devise', path: '../gems/spree_auth_devise'

gem 'spree_social', path: '../gems/spree_social'


# spree extensions for payments
gem 'spree_gateway', path: '../gems/spree_gateway'
gem 'spree_paypal_express', path: '../gems/better_spree_paypal_express'

gem 'spree_essentials', path: '../gems/spree_essentials'

# utils
# replacement for standard library.
gem 'addressable', require: false

gem 'rollout'

# masterpass gateway
gem 'spree_masterpass', :path => './spree_masterpass'

# Command line tools
gem 'term-ansicolor',   :require => false
gem 'ruby-progressbar', :require => false

gem 'sinatra',          :require => false

group :assets do
  gem 'bourbon'
  gem 'coffee-rails', '~> 4.1.1'
  gem 'coffee-script-source', '~> 1.8.0'
  gem 'uglifier', '1.3.0'
  gem 'execjs', '~> 2'
  gem 'eco'
  gem 'bootstrap-sass', '3.3.4.1'
end

group :development, :test do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'zeus'
  gem 'pry-rails'
  gem 'byebug'
  gem 'awesome_print'
  gem 'launchy', '~> 2.4'
  gem 'letter_opener', '~> 1.4.1'
  gem 'net-ssh', '~> 2.7.0'
  gem 'oink'
  gem 'quiet_assets'
  gem 'rspec-rails'
  gem 'spring'
  gem 'spring-commands-rspec'
  gem 'thin'
  gem 'meta_request'
end

group :test do
  gem 'capybara', '~> 2.5.0'
  gem 'capybara-screenshot', '~> 1.0.11'
  gem 'poltergeist', '~> 1.9.0'
  gem 'selenium-webdriver', '~> 2.53.0'
  gem 'show_me_the_cookies', '~> 3.1.0'
  gem 'turnip'
  gem 'database_cleaner', '0.9.1'
  gem 'factory_girl_rails', '4.2.1'
  gem 'rspec-activemodel-mocks'
  gem 'rspec-collection_matchers'
  gem 'rspec-retry'
  gem 'shoulda-matchers'
  gem 'timecop'
  gem 'vcr', '~> 2.9.3'
  gem 'webmock', '~> 1.21.0'
end

group :production do
  gem 'unicorn'
  gem 'aws-sdk'
end

gem 'mailchimp-api', require: 'mailchimp'
