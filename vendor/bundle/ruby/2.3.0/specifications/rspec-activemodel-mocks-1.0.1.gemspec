# -*- encoding: utf-8 -*-
# stub: rspec-activemodel-mocks 1.0.1 ruby lib

Gem::Specification.new do |s|
  s.name = "rspec-activemodel-mocks".freeze
  s.version = "1.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["David Chelimsky".freeze, "Andy Lindeman".freeze, "Thomas Holmes".freeze]
  s.date = "2014-06-02"
  s.description = "RSpec test doubles for ActiveModel and ActiveRecord".freeze
  s.email = "rspec@googlegroups.com".freeze
  s.homepage = "http://github.com/thomas-holmes/rspec-activemodel-mocks".freeze
  s.licenses = ["MIT".freeze]
  s.rdoc_options = ["--charset=UTF-8".freeze]
  s.rubyforge_project = "rspec".freeze
  s.rubygems_version = "2.5.2".freeze
  s.summary = "rspec-activemodel-mocks-1.0.1".freeze

  s.installed_by_version = "2.5.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activesupport>.freeze, [">= 3.0"])
      s.add_runtime_dependency(%q<activemodel>.freeze, [">= 3.0"])
      s.add_runtime_dependency(%q<rspec-mocks>.freeze, ["< 4.0", ">= 2.99"])
      s.add_development_dependency(%q<rake>.freeze, ["~> 10.0.0"])
      s.add_development_dependency(%q<cucumber>.freeze, ["~> 1.3.5"])
      s.add_development_dependency(%q<aruba>.freeze, ["~> 0.4.11"])
      s.add_development_dependency(%q<ZenTest>.freeze, ["~> 4.9.5"])
      s.add_development_dependency(%q<activerecord>.freeze, [">= 3.0"])
    else
      s.add_dependency(%q<activesupport>.freeze, [">= 3.0"])
      s.add_dependency(%q<activemodel>.freeze, [">= 3.0"])
      s.add_dependency(%q<rspec-mocks>.freeze, ["< 4.0", ">= 2.99"])
      s.add_dependency(%q<rake>.freeze, ["~> 10.0.0"])
      s.add_dependency(%q<cucumber>.freeze, ["~> 1.3.5"])
      s.add_dependency(%q<aruba>.freeze, ["~> 0.4.11"])
      s.add_dependency(%q<ZenTest>.freeze, ["~> 4.9.5"])
      s.add_dependency(%q<activerecord>.freeze, [">= 3.0"])
    end
  else
    s.add_dependency(%q<activesupport>.freeze, [">= 3.0"])
    s.add_dependency(%q<activemodel>.freeze, [">= 3.0"])
    s.add_dependency(%q<rspec-mocks>.freeze, ["< 4.0", ">= 2.99"])
    s.add_dependency(%q<rake>.freeze, ["~> 10.0.0"])
    s.add_dependency(%q<cucumber>.freeze, ["~> 1.3.5"])
    s.add_dependency(%q<aruba>.freeze, ["~> 0.4.11"])
    s.add_dependency(%q<ZenTest>.freeze, ["~> 4.9.5"])
    s.add_dependency(%q<activerecord>.freeze, [">= 3.0"])
  end
end
