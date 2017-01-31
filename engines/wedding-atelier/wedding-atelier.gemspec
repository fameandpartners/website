$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "wedding-atelier/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "wedding-atelier"
  s.version     = WeddingAtelier::VERSION
  s.authors     = ['Fame & Partners Dev Team']
  s.email       = ['dev@fameandpartners.com']
  s.summary     = 'Fame and Partners Wedding Atelier'
  s.description = 'Wedding Atelier to customize experience'
  s.homepage    = ''

  s.files = Dir["{app,config,db,lib}/**/*"] + ["Rakefile", "README.rdoc"]
  s.test_files = Dir["spec/**/*"]

  s.add_dependency 'rails', '~> 3.2.22.5'
  s.add_dependency 'bootstrap-sass', '~> 3.3.4.1'
  s.add_dependency 'rolify'
  s.add_dependency 'kaminari'        # Version specified on main app Gemfile (spree_core)
  s.add_dependency 'react-rails'
  s.add_dependency 'slim'            # Version specified on main app Gemfile
  s.add_dependency 'twilio-ruby'
  s.add_dependency 'active_model_serializers'
  s.add_development_dependency 'rspec-rails', '~> 3.2'
  s.add_development_dependency 'factory_girl_rails'
end
