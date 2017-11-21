# -*- encoding: utf-8 -*-
# stub: hashr 0.0.22 ruby lib

Gem::Specification.new do |s|
  s.name = "hashr".freeze
  s.version = "0.0.22"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Sven Fuchs".freeze]
  s.date = "2012-08-22"
  s.description = "Simple Hash extension to make working with nested hashes (e.g. for configuration) easier and less error-prone.".freeze
  s.email = "svenfuchs@artweb-design.de".freeze
  s.homepage = "http://github.com/svenfuchs/hashr".freeze
  s.rubyforge_project = "[none]".freeze
  s.rubygems_version = "2.5.2".freeze
  s.summary = "Simple Hash extension to make working with nested hashes (e.g. for configuration) easier and less error-prone".freeze

  s.installed_by_version = "2.5.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rake>.freeze, [">= 0"])
      s.add_development_dependency(%q<test_declarative>.freeze, [">= 0.0.2"])
    else
      s.add_dependency(%q<rake>.freeze, [">= 0"])
      s.add_dependency(%q<test_declarative>.freeze, [">= 0.0.2"])
    end
  else
    s.add_dependency(%q<rake>.freeze, [">= 0"])
    s.add_dependency(%q<test_declarative>.freeze, [">= 0.0.2"])
  end
end
