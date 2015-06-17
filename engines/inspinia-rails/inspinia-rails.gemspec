$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "inspinia-rails/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "inspinia-rails"
  s.version     = InspiniaRails::VERSION
  s.authors     = ["Garrow Bedrossian"]
  s.email       = ["garrowb@fameandpartners.com"]
  s.homepage    = "https://github.com/fameandpartners/inspina"
  s.summary     = "InspiniaRails theme assets gem"
  s.description = "Rails assets engine gem wrapper around Inspinia Theme"

  s.files = Dir["{app,config,db,lib,vendor}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  s.add_dependency "rails", "~> 3.2.21"
  s.add_dependency "bootstrap-sass" #, "~> 3.2.21"
  s.add_dependency "font-awesome-rails"

  s.add_development_dependency "sqlite3"
end
