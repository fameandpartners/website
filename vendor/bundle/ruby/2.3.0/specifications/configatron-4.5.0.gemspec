# -*- encoding: utf-8 -*-
# stub: configatron 4.5.0 ruby lib

Gem::Specification.new do |s|
  s.name = "configatron".freeze
  s.version = "4.5.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Mark Bates".freeze]
  s.date = "2014-12-17"
  s.description = "A powerful Ruby configuration system.".freeze
  s.email = ["mark@markbates.com".freeze]
  s.homepage = "https://github.com/markbates/configatron".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "2.5.2".freeze
  s.summary = "A powerful Ruby configuration system.".freeze

  s.installed_by_version = "2.5.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rake>.freeze, [">= 0"])
      s.add_development_dependency(%q<mocha>.freeze, [">= 0"])
      s.add_development_dependency(%q<subprocess>.freeze, [">= 0"])
      s.add_development_dependency(%q<minitest>.freeze, [">= 5.2.3"])
    else
      s.add_dependency(%q<rake>.freeze, [">= 0"])
      s.add_dependency(%q<mocha>.freeze, [">= 0"])
      s.add_dependency(%q<subprocess>.freeze, [">= 0"])
      s.add_dependency(%q<minitest>.freeze, [">= 5.2.3"])
    end
  else
    s.add_dependency(%q<rake>.freeze, [">= 0"])
    s.add_dependency(%q<mocha>.freeze, [">= 0"])
    s.add_dependency(%q<subprocess>.freeze, [">= 0"])
    s.add_dependency(%q<minitest>.freeze, [">= 5.2.3"])
  end
end
