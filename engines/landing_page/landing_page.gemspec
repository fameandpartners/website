$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "landing_page/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "landing_page"
  s.version     = LandingPage::VERSION
  s.authors     = ["Toby Hede"]
  s.email       = ["tobyh@fameandpartners.com"]
  s.homepage    = "http://fameandpartners.com"
  s.summary     = "LandingPage Engine."
  s.description = "Manages Landing Pages."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.13"

  s.add_development_dependency 'rspec-rails', '~> 3.1'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'factory_girl_rails'
  s.add_development_dependency 'pry'
  s.add_development_dependency 'pry-debugger'
  s.add_development_dependency 'rspec-activemodel-mocks'

end
