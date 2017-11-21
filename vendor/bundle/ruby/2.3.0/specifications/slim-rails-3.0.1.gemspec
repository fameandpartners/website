# -*- encoding: utf-8 -*-
# stub: slim-rails 3.0.1 ruby lib

Gem::Specification.new do |s|
  s.name = "slim-rails".freeze
  s.version = "3.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Leonardo Almeida".freeze]
  s.date = "2014-12-26"
  s.description = "Provides the generator settings required for Rails 3 and 4 to use Slim".freeze
  s.email = ["lalmeida08@gmail.com".freeze]
  s.homepage = "https://github.com/slim-template/slim-rails".freeze
  s.licenses = ["MIT".freeze]
  s.rubygems_version = "2.5.2".freeze
  s.summary = "Slim templates generator for Rails 3 and 4".freeze

  s.installed_by_version = "2.5.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rake>.freeze, ["~> 10.4"])
      s.add_development_dependency(%q<rocco>.freeze, ["~> 0.8"])
      s.add_development_dependency(%q<redcarpet>.freeze, ["~> 3.2"])
      s.add_development_dependency(%q<awesome_print>.freeze, ["~> 1.2"])
      s.add_development_dependency(%q<guard>.freeze, ["~> 2.10"])
      s.add_development_dependency(%q<guard-minitest>.freeze, ["~> 2.3"])
      s.add_development_dependency(%q<guard-rocco>.freeze, ["< 1.0.0", ">= 0.0.3"])
      s.add_runtime_dependency(%q<activesupport>.freeze, ["< 5.0", ">= 3.1"])
      s.add_runtime_dependency(%q<actionpack>.freeze, ["< 5.0", ">= 3.1"])
      s.add_runtime_dependency(%q<actionmailer>.freeze, ["< 5.0", ">= 3.1"])
      s.add_runtime_dependency(%q<railties>.freeze, ["< 5.0", ">= 3.1"])
      s.add_runtime_dependency(%q<slim>.freeze, ["~> 3.0"])
    else
      s.add_dependency(%q<rake>.freeze, ["~> 10.4"])
      s.add_dependency(%q<rocco>.freeze, ["~> 0.8"])
      s.add_dependency(%q<redcarpet>.freeze, ["~> 3.2"])
      s.add_dependency(%q<awesome_print>.freeze, ["~> 1.2"])
      s.add_dependency(%q<guard>.freeze, ["~> 2.10"])
      s.add_dependency(%q<guard-minitest>.freeze, ["~> 2.3"])
      s.add_dependency(%q<guard-rocco>.freeze, ["< 1.0.0", ">= 0.0.3"])
      s.add_dependency(%q<activesupport>.freeze, ["< 5.0", ">= 3.1"])
      s.add_dependency(%q<actionpack>.freeze, ["< 5.0", ">= 3.1"])
      s.add_dependency(%q<actionmailer>.freeze, ["< 5.0", ">= 3.1"])
      s.add_dependency(%q<railties>.freeze, ["< 5.0", ">= 3.1"])
      s.add_dependency(%q<slim>.freeze, ["~> 3.0"])
    end
  else
    s.add_dependency(%q<rake>.freeze, ["~> 10.4"])
    s.add_dependency(%q<rocco>.freeze, ["~> 0.8"])
    s.add_dependency(%q<redcarpet>.freeze, ["~> 3.2"])
    s.add_dependency(%q<awesome_print>.freeze, ["~> 1.2"])
    s.add_dependency(%q<guard>.freeze, ["~> 2.10"])
    s.add_dependency(%q<guard-minitest>.freeze, ["~> 2.3"])
    s.add_dependency(%q<guard-rocco>.freeze, ["< 1.0.0", ">= 0.0.3"])
    s.add_dependency(%q<activesupport>.freeze, ["< 5.0", ">= 3.1"])
    s.add_dependency(%q<actionpack>.freeze, ["< 5.0", ">= 3.1"])
    s.add_dependency(%q<actionmailer>.freeze, ["< 5.0", ">= 3.1"])
    s.add_dependency(%q<railties>.freeze, ["< 5.0", ">= 3.1"])
    s.add_dependency(%q<slim>.freeze, ["~> 3.0"])
  end
end
