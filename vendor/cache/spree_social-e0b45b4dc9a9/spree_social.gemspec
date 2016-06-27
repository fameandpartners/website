# -*- encoding: utf-8 -*-
# stub: spree_social 2.3.0 ruby lib

Gem::Specification.new do |s|
  s.name = "spree_social"
  s.version = "2.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["John Dyer"]
  s.date = "2016-05-13"
  s.email = "jdyer@spreecommerce.com"
  s.files = [".gitignore", ".rspec", ".travis.yml", "Gemfile", "LICENSE", "README.md", "Rakefile", "Versionfile", "app/assets/images/store/facebook_128.png", "app/assets/images/store/facebook_256.png", "app/assets/images/store/facebook_32.png", "app/assets/images/store/facebook_64.png", "app/assets/images/store/github_128.png", "app/assets/images/store/github_256.png", "app/assets/images/store/github_32.png", "app/assets/images/store/github_64.png", "app/assets/images/store/google_oauth2_128.png", "app/assets/images/store/google_oauth2_256.png", "app/assets/images/store/google_oauth2_32.png", "app/assets/images/store/google_oauth2_64.png", "app/assets/images/store/twitter_128.png", "app/assets/images/store/twitter_256.png", "app/assets/images/store/twitter_32.png", "app/assets/images/store/twitter_64.png", "app/assets/javascripts/admin/spree_social.js", "app/assets/javascripts/store/spree_social.js", "app/assets/stylesheets/admin/spree_social.css", "app/assets/stylesheets/store/spree_social.css", "app/controllers/spree/admin/authentication_methods_controller.rb", "app/controllers/spree/omniauth_callbacks_controller.rb", "app/controllers/spree/user_authentications_controller.rb", "app/controllers/spree/user_registrations_controller_decorator.rb", "app/helpers/spree/omniauth_callbacks_helper.rb", "app/models/spree/authentication_method.rb", "app/models/spree/social_configuration.rb", "app/models/spree/user_authentication.rb", "app/models/spree/user_decorator.rb", "app/overrides/add_authentications_to_account_summary.rb", "app/overrides/admin_configuration_decorator.rb", "app/overrides/user_registrations_decorator.rb", "app/views/spree/admin/authentication_methods/_form.html.erb", "app/views/spree/admin/authentication_methods/edit.html.erb", "app/views/spree/admin/authentication_methods/index.html.erb", "app/views/spree/admin/authentication_methods/new.html.erb", "app/views/spree/admin/shared/_configurations_menu.html.erb", "app/views/spree/shared/_social.html.erb", "app/views/spree/shared/_user_form.html.erb", "app/views/spree/users/_new-customer.html.erb", "app/views/spree/users/_social.html.erb", "config/initializers/devise.rb", "config/locales/de.yml", "config/locales/en.yml", "config/locales/nl.yml", "config/routes.rb", "db/migrate/20120120163432_create_user_authentications.rb", "db/migrate/20120123163222_create_authentication_methods.rb", "lib/generators/spree_social/install/install_generator.rb", "lib/spree_social.rb", "lib/spree_social/engine.rb", "script/rails", "spec/controllers/spree/omniauth_callbacks_controller_spec.rb", "spec/integration/sign_in_spec.rb", "spec/models/spree/user_decorator_spec.rb", "spec/spec_helper.rb", "spree_social.gemspec"]
  s.homepage = "http://www.spreecommerce.com"
  s.required_ruby_version = Gem::Requirement.new(">= 1.8.7")
  s.requirements = ["none"]
  s.rubygems_version = "2.4.7"
  s.summary = "Adds social network login services (OAuth) to Spree"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<spree_core>, ["~> 1.3.0"])
      s.add_runtime_dependency(%q<omniauth>, [">= 0"])
      s.add_runtime_dependency(%q<oa-core>, [">= 0"])
      s.add_runtime_dependency(%q<omniauth-twitter>, [">= 0"])
      s.add_runtime_dependency(%q<omniauth-facebook>, [">= 0"])
      s.add_runtime_dependency(%q<omniauth-github>, [">= 0"])
      s.add_runtime_dependency(%q<omniauth-google-oauth2>, [">= 0"])
      s.add_development_dependency(%q<capybara>, ["~> 1.1"])
      s.add_development_dependency(%q<ffaker>, [">= 0"])
      s.add_development_dependency(%q<rspec-rails>, ["~> 2.11.0"])
      s.add_development_dependency(%q<factory_girl_rails>, ["~> 1.7.0"])
      s.add_development_dependency(%q<pry>, [">= 0"])
      s.add_development_dependency(%q<shoulda-matchers>, ["~> 1.1"])
      s.add_development_dependency(%q<sqlite3>, [">= 0"])
      s.add_development_dependency(%q<launchy>, [">= 0"])
    else
      s.add_dependency(%q<spree_core>, ["~> 1.3.0"])
      s.add_dependency(%q<omniauth>, [">= 0"])
      s.add_dependency(%q<oa-core>, [">= 0"])
      s.add_dependency(%q<omniauth-twitter>, [">= 0"])
      s.add_dependency(%q<omniauth-facebook>, [">= 0"])
      s.add_dependency(%q<omniauth-github>, [">= 0"])
      s.add_dependency(%q<omniauth-google-oauth2>, [">= 0"])
      s.add_dependency(%q<capybara>, ["~> 1.1"])
      s.add_dependency(%q<ffaker>, [">= 0"])
      s.add_dependency(%q<rspec-rails>, ["~> 2.11.0"])
      s.add_dependency(%q<factory_girl_rails>, ["~> 1.7.0"])
      s.add_dependency(%q<pry>, [">= 0"])
      s.add_dependency(%q<shoulda-matchers>, ["~> 1.1"])
      s.add_dependency(%q<sqlite3>, [">= 0"])
      s.add_dependency(%q<launchy>, [">= 0"])
    end
  else
    s.add_dependency(%q<spree_core>, ["~> 1.3.0"])
    s.add_dependency(%q<omniauth>, [">= 0"])
    s.add_dependency(%q<oa-core>, [">= 0"])
    s.add_dependency(%q<omniauth-twitter>, [">= 0"])
    s.add_dependency(%q<omniauth-facebook>, [">= 0"])
    s.add_dependency(%q<omniauth-github>, [">= 0"])
    s.add_dependency(%q<omniauth-google-oauth2>, [">= 0"])
    s.add_dependency(%q<capybara>, ["~> 1.1"])
    s.add_dependency(%q<ffaker>, [">= 0"])
    s.add_dependency(%q<rspec-rails>, ["~> 2.11.0"])
    s.add_dependency(%q<factory_girl_rails>, ["~> 1.7.0"])
    s.add_dependency(%q<pry>, [">= 0"])
    s.add_dependency(%q<shoulda-matchers>, ["~> 1.1"])
    s.add_dependency(%q<sqlite3>, [">= 0"])
    s.add_dependency(%q<launchy>, [">= 0"])
  end
end
