$LOAD_PATH.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'revolution/version'

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = 'revolution'
  s.version     = Revolution::VERSION
  s.authors     = ['Toby Hede']
  s.email       = ['tobyh@fameandpartners.com']
  s.homepage    = 'http://famenandpartners.com'
  s.summary     = ''
  s.description = ''

  # s.files = Dir['{app,config,db,lib}/**/*'] + %w(['Rakefile'] ['README.rdoc'])
  s.test_files = Dir['test/**/*']

  s.add_dependency 'rails', '~> 3.2.21'
  s.add_dependency 'awesome_nested_set'

  s.add_development_dependency 'rspec-rails'
end
