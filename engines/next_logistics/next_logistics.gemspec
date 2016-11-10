$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "next_logistics/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "next_logistics"
  s.version     = NextLogistics::VERSION
  s.authors     = ['Fame & Partners Dev Team']
  s.email       = ['dev@fameandpartners.com']
  s.homepage    = 'https://github.com/fameandpartners/website/tree/master/engines/next_logistics'
  s.summary     = 'Next Logistics FTP 3PL integration'
  s.description = 'Next Logistics FTP 3PL integration'

  s.files = Dir['{app,config,db,lib}/**/*'] + ['Rakefile', 'README.rdoc']

  s.add_dependency 'rails'   # Version specified on main app Gemfile
  s.add_dependency 'sidekiq' # Version specified on main app Gemfile
  s.add_dependency 'aasm', '~> 4.10.0'

  s.add_development_dependency 'rspec' # Version specified on main app Gemfile
end
