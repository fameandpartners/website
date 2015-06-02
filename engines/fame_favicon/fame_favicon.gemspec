$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "fame_favicon/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "fame_favicon"
  s.version     = FameFavicon::VERSION
  s.authors     = ["Garrow Bedrossian"]
  s.email       = ["garrowb@fameandpartners.com"]
  s.homepage    = "fameandpartners.com"
  s.summary     = "Static contents for the favicon"
  s.description = "Fame Favicon in all it's glory, possibly reusable on other rails apps."

  s.files = Dir["{app,config,db,lib}/**/*"] + ["Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.21"

  s.add_development_dependency "sqlite3"
  s.add_development_dependency "minitest"
  s.add_development_dependency "capybara"
  s.add_development_dependency "pry"
end
