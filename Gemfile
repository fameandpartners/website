source 'https://rubygems.org'

gem 'rails', '3.2.13'
gem 'pg'
gem 'slim', '~> 1.3.8'
gem 'slim-rails', '~> 1.1.1'
gem 'configatron'
gem 'paperclip'
gem 'createsend', '~> 2.5.0'
gem 'sidekiq'
gem 'psych', '~> 1.3.4'
gem 'active_model_serializers'
gem 'data_migrate', git: 'git://github.com/droidlabs/data-migrate.git'

gem 'acts-as-taggable-on'
gem 'rmagick'
gem 'ckeditor'
gem 'newrelic_rpm'
gem 'default_value_for'
gem 'tire'

# assets
gem 'jquery-rails'
gem 'sass-rails',   '~> 3.2.3'

group :assets do
  gem 'bourbon'
  gem 'coffee-rails', '~> 3.2.1'
  gem 'uglifier', '1.3.0'
  gem 'execjs', '1.4.0'
  gem 'jquery-ui-rails'
  gem 'jquery-fileupload-rails', '0.3.4'
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
end

group :development, :test do
  gem 'debugger'
end

gem 'spree', :github => 'spree/spree', :branch => '1-3-stable'

# spree extensions for authentication
gem 'spree_auth_devise', :github => 'spree/spree_auth_devise', :branch => '1-3-stable'
gem 'spree_social', :github => 'spree/spree_social', :branch => '1-3-stable'

# spree extensions for payments
gem 'spree_gateway', :github => 'spree/spree_gateway', :branch => '1-3-stable'
gem 'spree_paypal_express', :github => 'spree/spree_paypal_express', :branch => '1-3-stable'

gem 'spree_essentials', :git => 'git://github.com/bbtfr/spree_essentials.git', :branch => '1.3.x'


group :production do
  gem 'unicorn'
end
