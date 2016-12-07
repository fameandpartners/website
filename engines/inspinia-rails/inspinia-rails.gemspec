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

  s.add_dependency 'rails'                            # Version specified on main app Gemfile
  s.add_dependency 'font-awesome-rails', '~> 4.3.0.0' # Version also specified on the admin_ui engine

  s.add_development_dependency "sqlite3"
end
