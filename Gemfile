source 'https://rubygems.org'
source 'https://rubygems.org'

gem 'rails', '3.2.13'
gem 'pg'
gem 'slim', '~> 1.3.8'
gem 'slim-rails', '~> 1.1.1'
gem 'configatron'
gem 'paperclip'
gem 'createsend', '~> 2.5.0'
gem 'sidekiq'
gem 'whenever'
gem 'psych', '~> 1.3.4'
gem 'active_model_serializers'
gem 'data_migrate', git: 'git://github.com/droidlabs/data-migrate.git'

gem 'acts-as-taggable-on'
gem 'rmagick'
gem 'ckeditor'
gem 'newrelic_rpm'
gem 'default_value_for'
gem 'tire'
gem 'redis-rails'
gem 'titleize'
gem 'mail_view', :git => 'https://github.com/37signals/mail_view.git'

gem 'geoip', require: false
gem 'rubyzip', '< 0.9.9', require: false
gem 'roo', require: false

gem 'twitter'
gem 'instagram'

gem 'sitemap_generator'

gem 'font-awesome-sass'

# assets
gem 'jquery-rails'
gem 'sass-rails',   '~> 3.2.3'
gem 'droidcss'

group :assets do
  gem 'bourbon'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '1.3.0'
  gem 'execjs', '1.4.0'
  gem 'jquery-ui-rails'
  gem 'jquery-fileupload-rails', '0.4.1'
  gem 'eco'
end

group :development do
  gem 'capistrano', '2.15.4', require: false
  gem 'capistrano-rbenv', '0.0.10', require: false
  gem 'launchy', '2.2.0'
  gem 'letter_opener', '0.0.2', git: 'git://github.com/droidlabs/letter_opener.git'
  gem 'quiet_assets', '1.0.2'
  gem 'thin', '1.5.1'
  gem 'pry-rails'
  gem 'pry-nav'
  gem 'debugger'
  gem "therubyracer"
  gem 'rails-dev-tweaks', '~> 1.1'
  gem 'oink'
end

group :test do
  gem 'rspec-rails', '~> 2.13.1'
  gem 'shoulda', '~> 3.4.0'
  gem 'database_cleaner', '0.9.1'
  gem 'factory_girl_rails', '4.2.1'
  gem 'mocha', '~> 0.13.3', require: 'mocha/setup'
end

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

group :staging do
  gem "therubyracer"
end

group :production do
  gem 'unicorn'
  gem 'aws-sdk'
end
