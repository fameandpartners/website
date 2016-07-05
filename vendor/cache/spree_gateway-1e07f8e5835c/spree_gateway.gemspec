# -*- encoding: utf-8 -*-
# stub: spree_gateway 1.2.0.rc2 ruby lib

Gem::Specification.new do |s|
  s.name = "spree_gateway"
  s.version = "1.2.0.rc2"

  s.required_rubygems_version = Gem::Requirement.new("> 1.3.1") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Spree Commerce"]
  s.date = "2016-05-13"
  s.description = "Additional Payment Gateways for Spree"
  s.homepage = "http://www.spreecommerce.org"
  s.required_ruby_version = Gem::Requirement.new(">= 1.8.7")
  s.requirements = ["none"]
  s.rubygems_version = "2.4.7"
  s.summary = "Spree Gateways"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<spree_core>, ["~> 1.0"])
      s.add_runtime_dependency(%q<savon>, ["~> 1.2"])
      s.add_development_dependency(%q<factory_girl_rails>, ["~> 1.7.0"])
      s.add_development_dependency(%q<rspec-rails>, [">= 0"])
      s.add_development_dependency(%q<sqlite3>, [">= 0"])
    else
      s.add_dependency(%q<spree_core>, ["~> 1.0"])
      s.add_dependency(%q<savon>, ["~> 1.2"])
      s.add_dependency(%q<factory_girl_rails>, ["~> 1.7.0"])
      s.add_dependency(%q<rspec-rails>, [">= 0"])
      s.add_dependency(%q<sqlite3>, [">= 0"])
    end
  else
    s.add_dependency(%q<spree_core>, ["~> 1.0"])
    s.add_dependency(%q<savon>, ["~> 1.2"])
    s.add_dependency(%q<factory_girl_rails>, ["~> 1.7.0"])
    s.add_dependency(%q<rspec-rails>, [">= 0"])
    s.add_dependency(%q<sqlite3>, [">= 0"])
  end
end
