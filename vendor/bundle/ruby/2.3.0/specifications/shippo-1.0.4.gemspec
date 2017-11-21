# -*- encoding: utf-8 -*-
# stub: shippo 1.0.4 ruby lib

Gem::Specification.new do |s|
  s.name = "shippo".freeze
  s.version = "1.0.4"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Shippo & Contributors".freeze]
  s.date = "2015-06-19"
  s.description = "Quick and easy access to the Shippo API".freeze
  s.email = "support@goshippo.com".freeze
  s.homepage = "http://goshippo.com".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "2.5.2".freeze
  s.summary = "Shippo API".freeze

  s.installed_by_version = "2.5.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rest-client>.freeze, ["~> 1.4"])
      s.add_runtime_dependency(%q<mime-types>.freeze, ["< 3.0", ">= 1.25"])
      s.add_runtime_dependency(%q<json>.freeze, ["~> 1.8.1"])
    else
      s.add_dependency(%q<rest-client>.freeze, ["~> 1.4"])
      s.add_dependency(%q<mime-types>.freeze, ["< 3.0", ">= 1.25"])
      s.add_dependency(%q<json>.freeze, ["~> 1.8.1"])
    end
  else
    s.add_dependency(%q<rest-client>.freeze, ["~> 1.4"])
    s.add_dependency(%q<mime-types>.freeze, ["< 3.0", ">= 1.25"])
    s.add_dependency(%q<json>.freeze, ["~> 1.8.1"])
  end
end
