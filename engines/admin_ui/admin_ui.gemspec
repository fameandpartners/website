$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "admin_ui/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "admin_ui"
  s.version     = AdminUi::VERSION
  s.authors     = ["Garrow Bedrossian"]
  s.email       = ["garrowb@fameandpartners.com"]
  s.homepage    = "http://fameandpartners.com/admin"
  s.summary     = "Container for Non-Spree Admin UI"
  s.description = ""

  s.files = Dir["{app,config,db,lib}/**/*"] + ["MIT-LICENSE", "Rakefile", "README.rdoc"]
  s.test_files = Dir["test/**/*"]

  # Base
  s.add_dependency "rails", "~> 3.2.21"
  s.add_dependency "cancan"
  s.add_dependency "money"

  # UI
  s.add_dependency "slim"
  s.add_dependency "sidekiq"
  s.add_dependency "kaminari"
  s.add_dependency "datagrid"
  s.add_dependency "reform"

  # Theme
  # s.add_dependency "inspinia-rails"
  s.add_dependency "font-awesome-rails"


  # Even with this here, the helper is not loaded unless the main app
  # also inlcudes 'active_link_to' in it's Gemfile.
  s.add_dependency "active_link_to"
end
