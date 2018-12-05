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
  s.add_dependency "rails", "~> 3.2.22.5"
  s.add_dependency "cancan"
  s.add_dependency "money"

  # UI
  s.add_dependency 'slim'        # Version specified on main app Gemfile
  s.add_dependency 'sidekiq'     # Version specified on main app Gemfile
  s.add_dependency 'simple_form' # Version specified on main app Gemfile
  s.add_dependency 'reform'      # Version specified on main app Gemfile
  s.add_dependency 'kaminari', '~> 0.14.1'
  s.add_dependency 'datagrid', '~> 1.4.0'
  s.add_dependency 'chosen-rails', '~> 1.5.1'

  # Theme
  # s.add_dependency "inspinia-rails"
  s.add_dependency 'font-awesome-rails', '~> 4.3.0.0'

  # Engines
  s.add_dependency 'manual_order'

  # Even with this here, the helper is not loaded unless the main app
  # also inlcudes 'active_link_to' in it's Gemfile.
  s.add_dependency 'active_link_to' # Version specified on main app Gemfile
end
