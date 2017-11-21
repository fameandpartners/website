# -*- encoding: utf-8 -*-
# stub: deface 0.9.1 ruby lib

Gem::Specification.new do |s|
  s.name = "deface".freeze
  s.version = "0.9.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Brian D Quinn".freeze]
  s.date = "2012-05-28"
  s.description = "Deface is a library that allows you to customize ERB & HAML views in a Rails application without editing the underlying view.".freeze
  s.email = "brian@spreecommerce.com".freeze
  s.extra_rdoc_files = ["README.markdown".freeze]
  s.files = ["README.markdown".freeze]
  s.homepage = "http://github.com/railsdog/deface".freeze
  s.rdoc_options = ["--charset=UTF-8".freeze]
  s.rubygems_version = "2.5.2".freeze
  s.summary = "Deface is a library that allows you to customize ERB & HAML views in Rails".freeze

  s.installed_by_version = "2.5.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<nokogiri>.freeze, ["~> 1.5.0"])
      s.add_runtime_dependency(%q<rails>.freeze, ["~> 3.1"])
      s.add_development_dependency(%q<rspec>.freeze, [">= 2.8.0"])
      s.add_development_dependency(%q<haml>.freeze, [">= 3.1.4"])
    else
      s.add_dependency(%q<nokogiri>.freeze, ["~> 1.5.0"])
      s.add_dependency(%q<rails>.freeze, ["~> 3.1"])
      s.add_dependency(%q<rspec>.freeze, [">= 2.8.0"])
      s.add_dependency(%q<haml>.freeze, [">= 3.1.4"])
    end
  else
    s.add_dependency(%q<nokogiri>.freeze, ["~> 1.5.0"])
    s.add_dependency(%q<rails>.freeze, ["~> 3.1"])
    s.add_dependency(%q<rspec>.freeze, [">= 2.8.0"])
    s.add_dependency(%q<haml>.freeze, [">= 3.1.4"])
  end
end
