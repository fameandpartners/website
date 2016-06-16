$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'manual_order/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'manual_order'
  s.version     = ManualOrder::VERSION
  s.authors     = ['Fame & Partners Dev Team']
  s.email       = ['dev@fameandpartners.com']
  s.homepage    = ''
  s.summary     = 'Manual order process implementation.'
  s.description = 'Manual order process implementation.'

  s.files = Dir['{app,config,db,lib}/**/*'] + ['Rakefile', 'README.rdoc']
  s.test_files = Dir['test/**/*']

  s.add_dependency 'rails', '~> 4.2.6'
  # s.add_dependency "jquery-rails"

  s.add_development_dependency 'sqlite3'
end
