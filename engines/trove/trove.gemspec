$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "trove/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "trove"
  s.version     = Trove::VERSION
  s.authors     = ["Toby Hede"]
  s.email       = ["tobyh@fameandpartners.com"]
  s.homepage    = "http://fameandpartners.com"
  s.summary     = ""
  s.description = ""

  s.files = Dir["{app,config,db,lib}/**/*"] + ["Rakefile", "README.rdoc"]
  # s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.21"
  s.add_dependency "elasticsearch-rails"
  s.add_dependency "elasticsearch-persistence"

  s.add_development_dependency 'sqlite3'
  s.add_development_dependency 'rspec-rails'
end
