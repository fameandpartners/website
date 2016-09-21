$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'afterpay/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'afterpay'
  s.version     = Afterpay::VERSION
  s.authors     = ['Fame & Partners Dev Team']
  s.email       = ['dev@fameandpartners.com']
  s.homepage    = 'https://github.com/fameandpartners/website/tree/master/engines/afterpay'
  s.summary     = 'Spree Wrapper to Afterpay Australian Payment Method'
  s.description = 'Spree Wrapper to Afterpay Australian Payment Method'

  s.files = Dir['{app,config,db,lib}/**/*'] + ['Rakefile', 'README.rdoc']
  s.test_files = Dir['spec/**/*']

  s.add_dependency 'rails'                 # Version specified on main app Gemfile
  s.add_dependency 'spree'                 # Version specified on main app Gemfile
  s.add_dependency 'spree'                 # Version specified on main app Gemfile
  s.add_dependency 'afterpay-sdk-merchant' # Version specified on main app Gemfile

  # s.add_development_dependency 'sqlite3'
end
