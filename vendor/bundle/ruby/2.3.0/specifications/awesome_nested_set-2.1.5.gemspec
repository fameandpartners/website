# -*- encoding: utf-8 -*-
# stub: awesome_nested_set 2.1.5 ruby lib

Gem::Specification.new do |s|
  s.name = "awesome_nested_set".freeze
  s.version = "2.1.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Brandon Keepers".freeze, "Daniel Morrison".freeze, "Philip Arndt".freeze]
  s.date = "2012-09-26"
  s.description = "An awesome nested set implementation for Active Record".freeze
  s.email = "info@collectiveidea.com".freeze
  s.extra_rdoc_files = ["README.rdoc".freeze]
  s.files = ["README.rdoc".freeze]
  s.homepage = "http://github.com/collectiveidea/awesome_nested_set".freeze
  s.rdoc_options = ["--main".freeze, "README.rdoc".freeze, "--inline-source".freeze, "--line-numbers".freeze]
  s.rubygems_version = "2.5.2".freeze
  s.summary = "An awesome nested set implementation for Active Record".freeze

  s.installed_by_version = "2.5.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activerecord>.freeze, [">= 3.0.0"])
      s.add_development_dependency(%q<rspec-rails>.freeze, ["~> 2.8"])
    else
      s.add_dependency(%q<activerecord>.freeze, [">= 3.0.0"])
      s.add_dependency(%q<rspec-rails>.freeze, ["~> 2.8"])
    end
  else
    s.add_dependency(%q<activerecord>.freeze, [">= 3.0.0"])
    s.add_dependency(%q<rspec-rails>.freeze, ["~> 2.8"])
  end
end
