# -*- encoding: utf-8 -*-
# stub: turnip 1.3.1 ruby lib

Gem::Specification.new do |s|
  s.name = "turnip".freeze
  s.version = "1.3.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Jonas Nicklas".freeze]
  s.date = "2015-06-23"
  s.description = "Provides the ability to define steps and run Gherkin files from with RSpec".freeze
  s.email = ["jonas.nicklas@gmail.com".freeze]
  s.homepage = "".freeze
  s.rubyforge_project = "turnip".freeze
  s.rubygems_version = "2.5.2".freeze
  s.summary = "Gherkin extension for RSpec".freeze

  s.installed_by_version = "2.5.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rspec>.freeze, ["< 4.0", ">= 2.14.0"])
      s.add_runtime_dependency(%q<gherkin>.freeze, [">= 2.5"])
      s.add_development_dependency(%q<rake>.freeze, [">= 0"])
      s.add_development_dependency(%q<pry>.freeze, [">= 0"])
    else
      s.add_dependency(%q<rspec>.freeze, ["< 4.0", ">= 2.14.0"])
      s.add_dependency(%q<gherkin>.freeze, [">= 2.5"])
      s.add_dependency(%q<rake>.freeze, [">= 0"])
      s.add_dependency(%q<pry>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<rspec>.freeze, ["< 4.0", ">= 2.14.0"])
    s.add_dependency(%q<gherkin>.freeze, [">= 2.5"])
    s.add_dependency(%q<rake>.freeze, [">= 0"])
    s.add_dependency(%q<pry>.freeze, [">= 0"])
  end
end
