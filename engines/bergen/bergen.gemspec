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
  s.test_files = Dir['test/**/*']

  s.add_dependency 'rails', '~> 3.2.22'
  s.add_dependency 'savon', '~> 1.2.0'

  # s.add_dependency 'jquery-rails'

  s.add_development_dependency 'sqlite3'
end
