# -*- encoding: utf-8 -*-
# stub: money 5.1.1 ruby lib

Gem::Specification.new do |s|
  s.name = "money".freeze
  s.version = "5.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.6".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Tobias Luetke".freeze, "Hongli Lai".freeze, "Jeremy McNevin".freeze, "Shane Emmons".freeze, "Simone Carletti".freeze]
  s.date = "2013-02-20"
  s.description = "This library aids one in handling money and different currencies.".freeze
  s.email = ["semmons99+RubyMoney@gmail.com".freeze]
  s.homepage = "http://rubymoney.github.com/money".freeze
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.2".freeze)
  s.rubygems_version = "2.5.2".freeze
  s.summary = "Money and currency exchange support library.".freeze

  s.installed_by_version = "2.5.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<i18n>.freeze, ["~> 0.6.0"])
      s.add_development_dependency(%q<rspec>.freeze, ["~> 2.11.0"])
      s.add_development_dependency(%q<yard>.freeze, ["~> 0.8.1"])
      s.add_development_dependency(%q<kramdown>.freeze, ["~> 0.14.0"])
    else
      s.add_dependency(%q<i18n>.freeze, ["~> 0.6.0"])
      s.add_dependency(%q<rspec>.freeze, ["~> 2.11.0"])
      s.add_dependency(%q<yard>.freeze, ["~> 0.8.1"])
      s.add_dependency(%q<kramdown>.freeze, ["~> 0.14.0"])
    end
  else
    s.add_dependency(%q<i18n>.freeze, ["~> 0.6.0"])
    s.add_dependency(%q<rspec>.freeze, ["~> 2.11.0"])
    s.add_dependency(%q<yard>.freeze, ["~> 0.8.1"])
    s.add_dependency(%q<kramdown>.freeze, ["~> 0.14.0"])
  end
end
