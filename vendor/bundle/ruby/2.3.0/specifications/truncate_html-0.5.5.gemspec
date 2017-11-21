# -*- encoding: utf-8 -*-
# stub: truncate_html 0.5.5 ruby lib

Gem::Specification.new do |s|
  s.name = "truncate_html".freeze
  s.version = "0.5.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Harold Gim\u{e9}nez".freeze]
  s.date = "2012-04-24"
  s.description = "Truncates html so you don't have to".freeze
  s.email = ["harold.gimenez@gmail.com".freeze]
  s.homepage = "https://github.com/hgimenez/truncate_html".freeze
  s.rubygems_version = "2.5.2".freeze
  s.summary = "Uses an API similar to Rails' truncate helper to truncate HTML and close any lingering open tags.".freeze

  s.installed_by_version = "2.5.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rspec-rails>.freeze, ["~> 2.9"])
      s.add_development_dependency(%q<rails>.freeze, ["~> 3.0.3"])
    else
      s.add_dependency(%q<rspec-rails>.freeze, ["~> 2.9"])
      s.add_dependency(%q<rails>.freeze, ["~> 3.0.3"])
    end
  else
    s.add_dependency(%q<rspec-rails>.freeze, ["~> 2.9"])
    s.add_dependency(%q<rails>.freeze, ["~> 3.0.3"])
  end
end
