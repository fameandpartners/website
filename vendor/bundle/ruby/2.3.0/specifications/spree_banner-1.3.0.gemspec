# -*- encoding: utf-8 -*-
# stub: spree_banner 1.3.0 ruby lib

Gem::Specification.new do |s|
  s.name = "spree_banner".freeze
  s.version = "1.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Damiano Giacomello".freeze]
  s.date = "2013-03-13"
  s.email = "damiano.giacomello@diginess.it".freeze
  s.required_ruby_version = Gem::Requirement.new(">= 1.8.7".freeze)
  s.requirements = ["none".freeze]
  s.rubygems_version = "2.5.2".freeze
  s.summary = "Extension to manage banner for you Spree Shop".freeze

  s.installed_by_version = "2.5.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<spree_core>.freeze, [">= 1.3.0"])
      s.add_runtime_dependency(%q<paperclip>.freeze, [">= 0"])
      s.add_runtime_dependency(%q<aws-sdk>.freeze, [">= 0"])
    else
      s.add_dependency(%q<spree_core>.freeze, [">= 1.3.0"])
      s.add_dependency(%q<paperclip>.freeze, [">= 0"])
      s.add_dependency(%q<aws-sdk>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<spree_core>.freeze, [">= 1.3.0"])
    s.add_dependency(%q<paperclip>.freeze, [">= 0"])
    s.add_dependency(%q<aws-sdk>.freeze, [">= 0"])
  end
end
