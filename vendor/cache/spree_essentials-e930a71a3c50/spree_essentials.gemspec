# -*- encoding: utf-8 -*-
# stub: spree_essentials 0.7.0 ruby lib

Gem::Specification.new do |s|
  s.name = "spree_essentials"
  s.version = "0.7.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Spencer Steffen"]
  s.date = "2016-05-13"
  s.description = "Spree Essentials provides a base for several other Spree Commerce extensions. The idea is to provide other extensions with common functionality such as an asset-upload interface, a markdown editor, and a common admin-navigation tab."
  s.email = ["spencer@citrusme.com"]
  s.files = [".gitignore", ".travis.yml", "CHANGELOG.md", "Gemfile", "LICENSE", "README.md", "Rakefile", "Versionfile", "app/assets/images/admin/icons/pages.png", "app/assets/images/blog/rss.png", "app/assets/javascripts/.gitkeep", "app/assets/javascripts/admin/date.js", "app/assets/javascripts/admin/jquery.autodate.js", "app/assets/javascripts/admin/spree_essentials.js", "app/assets/stylesheets/.gitkeep", "app/assets/stylesheets/admin/spree_essentials.css", "app/controllers/spree/admin/markdown_controller.rb", "app/helpers/spree/admin/spree_essentials_helper.rb", "app/overrides/admin/spree_essentials.rb", "app/validators/datetime_validator.rb", "app/views/spree/admin/shared/_contents_sub_menu.html.erb", "app/views/spree/admin/shared/_contents_tab.html.erb", "config/locales/en.yml", "config/locales/it.yml", "config/locales/pl.yml", "config/locales/ru.yml", "config/routes.rb", "lib/generators/spree_essentials/install_generator.rb", "lib/spree_essentials.rb", "lib/spree_essentials/engine.rb", "lib/spree_essentials/testing/integration_case.rb", "lib/spree_essentials/testing/test_helper.rb", "lib/spree_essentials/version.rb", "spree_essentials.gemspec", "test/dummy_hooks/after_migrate.rb.sample", "test/dummy_hooks/before_migrate.rb", "test/dummy_hooks/templates/admin/all.css", "test/dummy_hooks/templates/admin/all.js", "test/dummy_hooks/templates/spree_user_error_fix.rb", "test/dummy_hooks/templates/store/all.css", "test/dummy_hooks/templates/store/all.js", "test/dummy_hooks/templates/store/screen.css", "test/integration/spree/admin/extension_integration_test.rb", "test/integration/spree/admin/markdown_integration_test.rb", "test/integration/spree/admin/upload_integration_test.rb", "test/integration_test_helper.rb", "test/spree_essential_example/README.md", "test/spree_essential_example/app/controllers/spree/admin/examples_controller.rb", "test/spree_essential_example/app/models/spree/example.rb", "test/spree_essential_example/app/views/spree/admin/examples/_form.html.erb", "test/spree_essential_example/app/views/spree/admin/examples/edit.html.erb", "test/spree_essential_example/app/views/spree/admin/examples/index.html.erb", "test/spree_essential_example/app/views/spree/admin/examples/new.html.erb", "test/spree_essential_example/app/views/spree/admin/examples/show.html.erb", "test/spree_essential_example/config/routes.rb", "test/spree_essential_example/db/migrate/20120307043727_create_spree_examples.rb", "test/spree_essential_example/lib/generators/spree_essentials/example_generator.rb", "test/spree_essential_example/lib/spree_essential_example.rb", "test/spree_essential_example/lib/spree_essential_example/engine.rb", "test/spree_essential_example/lib/spree_essential_example/version.rb", "test/spree_essential_example/spree_essential_example.gemspec", "test/support/files/1.gif", "test/support/files/1.jpg", "test/support/files/1.png", "test/support/files/2.gif", "test/support/files/2.jpg", "test/support/files/2.png", "test/support/files/3.gif", "test/support/files/3.jpg", "test/support/files/3.png", "test/support/files/test.pdf", "test/support/files/test.zip", "test/test_helper.rb", "test/unit/spree/asset_test.rb", "test/unit/spree/extension_test.rb", "test/unit/spree/helpers/admin/spree_essentials_helper_test.rb", "test/unit/spree/upload_test.rb", "test/unit/validators/datetime_validator_test.rb"]
  s.homepage = "https://github.com/citrus/spree_essentials"
  s.rubygems_version = "2.4.7"
  s.summary = "Spree Essentials provides a base for several other Spree Commerce extensions. See readme for details..."
  s.test_files = ["test/dummy_hooks/after_migrate.rb.sample", "test/dummy_hooks/before_migrate.rb", "test/dummy_hooks/templates/admin/all.css", "test/dummy_hooks/templates/admin/all.js", "test/dummy_hooks/templates/spree_user_error_fix.rb", "test/dummy_hooks/templates/store/all.css", "test/dummy_hooks/templates/store/all.js", "test/dummy_hooks/templates/store/screen.css", "test/integration/spree/admin/extension_integration_test.rb", "test/integration/spree/admin/markdown_integration_test.rb", "test/integration/spree/admin/upload_integration_test.rb", "test/integration_test_helper.rb", "test/spree_essential_example/README.md", "test/spree_essential_example/app/controllers/spree/admin/examples_controller.rb", "test/spree_essential_example/app/models/spree/example.rb", "test/spree_essential_example/app/views/spree/admin/examples/_form.html.erb", "test/spree_essential_example/app/views/spree/admin/examples/edit.html.erb", "test/spree_essential_example/app/views/spree/admin/examples/index.html.erb", "test/spree_essential_example/app/views/spree/admin/examples/new.html.erb", "test/spree_essential_example/app/views/spree/admin/examples/show.html.erb", "test/spree_essential_example/config/routes.rb", "test/spree_essential_example/db/migrate/20120307043727_create_spree_examples.rb", "test/spree_essential_example/lib/generators/spree_essentials/example_generator.rb", "test/spree_essential_example/lib/spree_essential_example.rb", "test/spree_essential_example/lib/spree_essential_example/engine.rb", "test/spree_essential_example/lib/spree_essential_example/version.rb", "test/spree_essential_example/spree_essential_example.gemspec", "test/support/files/1.gif", "test/support/files/1.jpg", "test/support/files/1.png", "test/support/files/2.gif", "test/support/files/2.jpg", "test/support/files/2.png", "test/support/files/3.gif", "test/support/files/3.jpg", "test/support/files/3.png", "test/support/files/test.pdf", "test/support/files/test.zip", "test/test_helper.rb", "test/unit/spree/asset_test.rb", "test/unit/spree/extension_test.rb", "test/unit/spree/helpers/admin/spree_essentials_helper_test.rb", "test/unit/spree/upload_test.rb", "test/unit/validators/datetime_validator_test.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<spree_core>, ["~> 1.3.0"])
      s.add_runtime_dependency(%q<rdiscount>, ["~> 1.6.8"])
      s.add_development_dependency(%q<shoulda>, ["~> 3.0.0"])
      s.add_development_dependency(%q<dummier>, ["~> 0.3.0"])
      s.add_development_dependency(%q<factory_girl>, ["~> 2.6.0"])
      s.add_development_dependency(%q<capybara>, ["~> 1.1.2"])
      s.add_development_dependency(%q<sqlite3>, ["~> 1.3.4"])
      s.add_development_dependency(%q<simplecov>, ["~> 0.6.1"])
    else
      s.add_dependency(%q<spree_core>, ["~> 1.3.0"])
      s.add_dependency(%q<rdiscount>, ["~> 1.6.8"])
      s.add_dependency(%q<shoulda>, ["~> 3.0.0"])
      s.add_dependency(%q<dummier>, ["~> 0.3.0"])
      s.add_dependency(%q<factory_girl>, ["~> 2.6.0"])
      s.add_dependency(%q<capybara>, ["~> 1.1.2"])
      s.add_dependency(%q<sqlite3>, ["~> 1.3.4"])
      s.add_dependency(%q<simplecov>, ["~> 0.6.1"])
    end
  else
    s.add_dependency(%q<spree_core>, ["~> 1.3.0"])
    s.add_dependency(%q<rdiscount>, ["~> 1.6.8"])
    s.add_dependency(%q<shoulda>, ["~> 3.0.0"])
    s.add_dependency(%q<dummier>, ["~> 0.3.0"])
    s.add_dependency(%q<factory_girl>, ["~> 2.6.0"])
    s.add_dependency(%q<capybara>, ["~> 1.1.2"])
    s.add_dependency(%q<sqlite3>, ["~> 1.3.4"])
    s.add_dependency(%q<simplecov>, ["~> 0.6.1"])
  end
end
