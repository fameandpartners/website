# -*- encoding: utf-8 -*-
# stub: httpi 1.1.1 ruby lib

Gem::Specification.new do |s|
  s.name = "httpi".freeze
  s.version = "1.1.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Daniel Harrington".freeze, "Martin Tepper".freeze]
  s.date = "2012-07-01"
  s.description = "HTTPI provides a common interface for Ruby HTTP libraries.".freeze
  s.email = "me@rubiii.com".freeze
  s.homepage = "http://github.com/rubiii/httpi".freeze
  s.rubyforge_project = "httpi".freeze
  s.rubygems_version = "2.5.2".freeze
  s.summary = "Interface for Ruby HTTP libraries".freeze

  s.installed_by_version = "2.5.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rack>.freeze, [">= 0"])
      s.add_development_dependency(%q<rake>.freeze, ["~> 0.8.7"])
      s.add_development_dependency(%q<rspec>.freeze, ["~> 2.7"])
      s.add_development_dependency(%q<mocha>.freeze, ["~> 0.9.9"])
      s.add_development_dependency(%q<webmock>.freeze, ["~> 1.4.0"])
      s.add_development_dependency(%q<autotest>.freeze, [">= 0"])
      s.add_development_dependency(%q<ZenTest>.freeze, ["= 4.5.0"])
    else
      s.add_dependency(%q<rack>.freeze, [">= 0"])
      s.add_dependency(%q<rake>.freeze, ["~> 0.8.7"])
      s.add_dependency(%q<rspec>.freeze, ["~> 2.7"])
      s.add_dependency(%q<mocha>.freeze, ["~> 0.9.9"])
      s.add_dependency(%q<webmock>.freeze, ["~> 1.4.0"])
      s.add_dependency(%q<autotest>.freeze, [">= 0"])
      s.add_dependency(%q<ZenTest>.freeze, ["= 4.5.0"])
    end
  else
    s.add_dependency(%q<rack>.freeze, [">= 0"])
    s.add_dependency(%q<rake>.freeze, ["~> 0.8.7"])
    s.add_dependency(%q<rspec>.freeze, ["~> 2.7"])
    s.add_dependency(%q<mocha>.freeze, ["~> 0.9.9"])
    s.add_dependency(%q<webmock>.freeze, ["~> 1.4.0"])
    s.add_dependency(%q<autotest>.freeze, [">= 0"])
    s.add_dependency(%q<ZenTest>.freeze, ["= 4.5.0"])
  end
end
