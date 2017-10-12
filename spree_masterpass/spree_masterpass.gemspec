# frozen_string_literal: true.

Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'spree_masterpass'
  s.version     = '0.1.0'
  s.summary     = 'Adds MasterPass as a Payment Method to Spree Commerce'
  s.description = s.summary
  s.required_ruby_version = '>= 1.8.7'

  s.author    = 'Thomas Lee'
  s.email     = 'lucky.thomaslee@gmail.com'
  # s.homepage  = 'http://www.spreecommerce.com'

  # s.files       = `git ls-files`.split("\n")
  # s.test_files  = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.require_path = 'lib'
  s.requirements << 'none'

  s.add_dependency 'spree_core', '~> 1.3.6.beta'
  s.add_dependency 'mastercard_masterpass_api'
  s.add_dependency 'mastercard_api'
  s.add_dependency 'mumboe-soap4r'

  s.add_development_dependency 'capybara', '~> 2.0'
  s.add_development_dependency 'coffee-rails'
  s.add_development_dependency 'factory_girl', '~> 4.2'
  s.add_development_dependency 'ffaker'
  s.add_development_dependency 'rspec-rails', '~> 2.13'
  s.add_development_dependency 'sass-rails'
  s.add_development_dependency 'sqlite3'
end
