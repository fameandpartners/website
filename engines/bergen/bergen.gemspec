$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'bergen/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'bergen'
  s.version     = Bergen::VERSION
  s.authors     = ['Fame & Partners Dev Team']
  s.email       = ['dev@fameandpartners.com']
  s.homepage    = 'https://github.com/fameandpartners/website/tree/master/engines/bergen'
  s.summary     = 'Libraries to connect to Bergen/WMS API'
  s.description = 'Libraries to connect to Bergen/WMS API'

  s.files = Dir['{app,config,db,lib}/**/*'] + ['Rakefile', 'README.rdoc']
  s.test_files = Dir['spec/**/*']

  s.add_dependency 'rails'             # Version specified on main app Gemfile
  s.add_dependency 'sidekiq'           # Version specified on main app Gemfile
  s.add_dependency 'sentry-raven'      # Version specified on main app Gemfile
  s.add_dependency 'money', '~> 5.1.1' # Version also specified on spree_core
  s.add_dependency 'savon', '~> 1.2.0' # Version also specified on spree_gateway
  s.add_dependency 'aasm', '~> 4.10.0'
  s.add_dependency 'shippo', '~> 1.0.4'

  # Related Engines dependency
  s.add_dependency 'admin_ui'

  # s.add_dependency 'jquery-rails'

  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'factory_girl'
end
