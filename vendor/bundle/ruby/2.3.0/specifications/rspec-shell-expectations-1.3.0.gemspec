# -*- encoding: utf-8 -*-
# stub: rspec-shell-expectations 1.3.0 ruby lib

Gem::Specification.new do |s|
  s.name = "rspec-shell-expectations".freeze
  s.version = "1.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Matthijs Groen".freeze]
  s.date = "2015-05-05"
  s.description = "    Stub results of commands.\n    Assert calls and input using RSpec for your shell scripts\n".freeze
  s.email = ["matthijs.groen@gmail.com".freeze]
  s.executables = ["stub".freeze]
  s.files = ["bin/stub".freeze]
  s.homepage = "".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "2.5.2".freeze
  s.summary = "Fake execution environments to TDD shell scripts".freeze

  s.installed_by_version = "2.5.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<bundler>.freeze, [">= 1.6"])
      s.add_development_dependency(%q<rake>.freeze, ["~> 10.0"])
    else
      s.add_dependency(%q<bundler>.freeze, [">= 1.6"])
      s.add_dependency(%q<rake>.freeze, ["~> 10.0"])
    end
  else
    s.add_dependency(%q<bundler>.freeze, [">= 1.6"])
    s.add_dependency(%q<rake>.freeze, ["~> 10.0"])
  end
end
