# -*- encoding: utf-8 -*-
# stub: oa-core 0.3.2 ruby lib

Gem::Specification.new do |s|
  s.name = "oa-core".freeze
  s.version = "0.3.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.6".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Michael Bleigh".freeze, "Erik Michaels-Ober".freeze]
  s.date = "2011-10-20"
  s.description = "Core strategies for OmniAuth.".freeze
  s.email = ["michael@intridea.com".freeze, "sferik@gmail.com".freeze]
  s.homepage = "http://github.com/intridea/omniauth".freeze
  s.rubygems_version = "2.5.2".freeze
  s.summary = "Core strategies for OmniAuth.".freeze

  s.installed_by_version = "2.5.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rack-test>.freeze, ["~> 0.5"])
      s.add_development_dependency(%q<rake>.freeze, ["~> 0.8"])
      s.add_development_dependency(%q<rdiscount>.freeze, ["~> 1.6"])
      s.add_development_dependency(%q<rspec>.freeze, ["~> 2.5"])
      s.add_development_dependency(%q<simplecov>.freeze, ["~> 0.4"])
      s.add_development_dependency(%q<yard>.freeze, ["~> 0.7"])
    else
      s.add_dependency(%q<rack-test>.freeze, ["~> 0.5"])
      s.add_dependency(%q<rake>.freeze, ["~> 0.8"])
      s.add_dependency(%q<rdiscount>.freeze, ["~> 1.6"])
      s.add_dependency(%q<rspec>.freeze, ["~> 2.5"])
      s.add_dependency(%q<simplecov>.freeze, ["~> 0.4"])
      s.add_dependency(%q<yard>.freeze, ["~> 0.7"])
    end
  else
    s.add_dependency(%q<rack-test>.freeze, ["~> 0.5"])
    s.add_dependency(%q<rake>.freeze, ["~> 0.8"])
    s.add_dependency(%q<rdiscount>.freeze, ["~> 1.6"])
    s.add_dependency(%q<rspec>.freeze, ["~> 2.5"])
    s.add_dependency(%q<simplecov>.freeze, ["~> 0.4"])
    s.add_dependency(%q<yard>.freeze, ["~> 0.7"])
  end
end
