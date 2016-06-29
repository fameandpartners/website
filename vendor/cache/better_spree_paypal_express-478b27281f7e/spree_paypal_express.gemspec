# -*- encoding: utf-8 -*-
# stub: spree_paypal_express 2.0.3 ruby lib

Gem::Specification.new do |s|
  s.name = "spree_paypal_express"
  s.version = "2.0.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Spree Commerce"]
  s.date = "2016-05-13"
  s.description = "Adds PayPal Express as a Payment Method to Spree Commerce"
  s.email = "gems@spreecommerce.com"
  s.files = [".gitignore", ".rspec", ".travis.yml", "CONTRIBUTING.md", "Gemfile", "LICENSE.md", "README.md", "Rakefile", "app/assets/javascripts/admin/spree_paypal_express.js", "app/assets/javascripts/store/spree_paypal_express.js", "app/assets/stylesheets/admin/spree_paypal_express.css", "app/controllers/spree/admin/payments_controller_decorator.rb", "app/controllers/spree/admin/paypal_payments_controller.rb", "app/controllers/spree/paypal_controller.rb", "app/models/spree/gateway/pay_pal_express.rb", "app/models/spree/paypal_express_checkout.rb", "app/views/spree/admin/payments/_paypal_complete.html.erb", "app/views/spree/admin/payments/paypal_refund.html.erb", "app/views/spree/admin/payments/source_forms/_paypal.html.erb", "app/views/spree/admin/payments/source_views/_paypal.html.erb", "app/views/spree/checkout/payment/_paypal.html.erb", "config/locales/en.yml", "config/routes.rb", "db/migrate/20130723042610_create_spree_paypal_express_checkouts.rb", "db/migrate/20130808030836_add_transaction_id_to_spree_paypal_express_checkouts.rb", "db/migrate/20130809013846_add_state_to_spree_paypal_express_checkouts.rb", "db/migrate/20130809014319_add_refunded_fields_to_spree_paypal_express_checkouts.rb", "lib/generators/spree_paypal_express/install/install_generator.rb", "lib/spree/i18n.rb", "lib/spree_paypal_express.rb", "lib/spree_paypal_express/engine.rb", "lib/spree_paypal_express/factories.rb", "lib/spree_paypal_express/version.rb", "script/rails", "spec/controllers/admin/paypal_refunds_controller_spec.rb", "spec/features/paypal_spec.rb", "spec/helpers/admin/paypal_refunds_helper_spec.rb", "spec/models/pay_pal_express_spec.rb", "spec/spec_helper.rb", "spree_paypal_express.gemspec"]
  s.homepage = "http://www.spreecommerce.com"
  s.licenses = ["BSD-3"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.3")
  s.requirements = ["none"]
  s.rubygems_version = "2.4.7"
  s.summary = "Adds PayPal Express as a Payment Method to Spree Commerce"
  s.test_files = ["spec/controllers/admin/paypal_refunds_controller_spec.rb", "spec/features/paypal_spec.rb", "spec/helpers/admin/paypal_refunds_helper_spec.rb", "spec/models/pay_pal_express_spec.rb", "spec/spec_helper.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<spree_core>, ["~> 1.3.3"])
      s.add_runtime_dependency(%q<paypal-sdk-merchant>, ["= 1.103.0"])
      s.add_development_dependency(%q<capybara>, ["~> 2.1"])
      s.add_development_dependency(%q<coffee-rails>, [">= 0"])
      s.add_development_dependency(%q<database_cleaner>, [">= 0"])
      s.add_development_dependency(%q<factory_girl>, ["~> 4.2"])
      s.add_development_dependency(%q<ffaker>, [">= 0"])
      s.add_development_dependency(%q<rspec-rails>, ["~> 2.13"])
      s.add_development_dependency(%q<sass-rails>, [">= 0"])
      s.add_development_dependency(%q<selenium-webdriver>, [">= 0"])
      s.add_development_dependency(%q<simplecov>, [">= 0"])
      s.add_development_dependency(%q<sqlite3>, [">= 0"])
      s.add_development_dependency(%q<pry>, [">= 0"])
    else
      s.add_dependency(%q<spree_core>, ["~> 1.3.3"])
      s.add_dependency(%q<paypal-sdk-merchant>, ["= 1.103.0"])
      s.add_dependency(%q<capybara>, ["~> 2.1"])
      s.add_dependency(%q<coffee-rails>, [">= 0"])
      s.add_dependency(%q<database_cleaner>, [">= 0"])
      s.add_dependency(%q<factory_girl>, ["~> 4.2"])
      s.add_dependency(%q<ffaker>, [">= 0"])
      s.add_dependency(%q<rspec-rails>, ["~> 2.13"])
      s.add_dependency(%q<sass-rails>, [">= 0"])
      s.add_dependency(%q<selenium-webdriver>, [">= 0"])
      s.add_dependency(%q<simplecov>, [">= 0"])
      s.add_dependency(%q<sqlite3>, [">= 0"])
      s.add_dependency(%q<pry>, [">= 0"])
    end
  else
    s.add_dependency(%q<spree_core>, ["~> 1.3.3"])
    s.add_dependency(%q<paypal-sdk-merchant>, ["= 1.103.0"])
    s.add_dependency(%q<capybara>, ["~> 2.1"])
    s.add_dependency(%q<coffee-rails>, [">= 0"])
    s.add_dependency(%q<database_cleaner>, [">= 0"])
    s.add_dependency(%q<factory_girl>, ["~> 4.2"])
    s.add_dependency(%q<ffaker>, [">= 0"])
    s.add_dependency(%q<rspec-rails>, ["~> 2.13"])
    s.add_dependency(%q<sass-rails>, [">= 0"])
    s.add_dependency(%q<selenium-webdriver>, [">= 0"])
    s.add_dependency(%q<simplecov>, [">= 0"])
    s.add_dependency(%q<sqlite3>, [">= 0"])
    s.add_dependency(%q<pry>, [">= 0"])
  end
end
