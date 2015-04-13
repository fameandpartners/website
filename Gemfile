source 'https://rubygems.org'

gem 'rails', '3.2.21'
gem 'pg'
gem 'slim'
gem 'slim-rails'
gem 'configatron'
gem 'paperclip'
gem 'createsend', '~> 2.5.0'
gem 'sidekiq', '2.13.0'
gem 'timers', '1.1.0'
gem 'whenever'
gem 'psych', '~> 1.3.4'
gem 'active_model_serializers'
gem 'data_migrate', git: 'git://github.com/droidlabs/data-migrate.git'
gem 'rack-cors'
gem 'business_time'
gem 'acts-as-taggable-on'
gem 'rmagick'
gem 'ckeditor'
gem 'newrelic_rpm'
gem 'default_value_for'
gem 'tire'
gem 'redis-rails'
gem 'titleize'

gem 'geoip', require: false
gem 'rubyzip', '< 0.9.9', require: false
gem 'roo', require: false

gem 'twitter'
gem 'instagram'
gem 'google_drive', '1.0.0', require: false # parse spread sheet

gem 'sitemap_generator'

gem 'font-awesome-sass'

gem 'canonical-rails', github: 'jumph4x/canonical-rails'

gem 'pry-rails'

# assets
gem 'jquery-rails'
gem 'sass-rails',   '~> 3.2.3'
gem 'droidcss'

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
# replacement for standart library.
gem 'addressable', require: false

gem 'rollout'

gem 'term-ansicolor'

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

group :development, :test do
  gem 'awesome_print'
  gem 'capistrano', '2.15.4', require: false
  gem 'capistrano-rbenv', '0.0.10', require: false
  gem 'capybara'
  gem 'database_cleaner', '0.9.1'
  gem 'factory_girl_rails', '4.2.1'
  gem 'launchy', '2.2.0'
  gem 'letter_opener', '0.0.2', git: 'git://github.com/droidlabs/letter_opener.git'
  gem 'mail_view', :git => 'https://github.com/37signals/mail_view.git'
  gem 'net-ssh', '~> 2.7.0'
  gem 'oink'
  gem 'pry'
  gem 'pry-debugger'
  gem 'quiet_assets', '1.0.2'
  gem 'rspec-activemodel-mocks'
  gem 'rspec-rails', '~> 3.1'
  gem 'shoulda-matchers'
  gem 'spring'
  gem 'thin', '1.5.1'
  gem 'compass'

end

group :staging, :development do
  gem 'libv8', '~> 3.16'
  gem 'therubyracer'
end

group :production do
  gem 'unicorn'
  gem 'aws-sdk'
end
