# -*- encoding: utf-8 -*-
# stub: wasabi 2.5.1 ruby lib

Gem::Specification.new do |s|
  s.name = "wasabi".freeze
  s.version = "2.5.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Daniel Harrington".freeze]
  s.date = "2012-08-22"
  s.description = "A simple WSDL parser".freeze
  s.email = ["me@rubiii.com".freeze]
  s.homepage = "https://github.com/rubiii/wasabi".freeze
  s.rubyforge_project = "wasabi".freeze
  s.rubygems_version = "2.5.2".freeze
  s.summary = "A simple WSDL parser".freeze

  s.installed_by_version = "2.5.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<httpi>.freeze, ["~> 1.0"])
      s.add_runtime_dependency(%q<nokogiri>.freeze, [">= 1.4.0"])
      s.add_development_dependency(%q<rake>.freeze, ["~> 0.9"])
      s.add_development_dependency(%q<rspec>.freeze, ["~> 2.10"])
    else
      s.add_dependency(%q<httpi>.freeze, ["~> 1.0"])
      s.add_dependency(%q<nokogiri>.freeze, [">= 1.4.0"])
      s.add_dependency(%q<rake>.freeze, ["~> 0.9"])
      s.add_dependency(%q<rspec>.freeze, ["~> 2.10"])
    end
  else
    s.add_dependency(%q<httpi>.freeze, ["~> 1.0"])
    s.add_dependency(%q<nokogiri>.freeze, [">= 1.4.0"])
    s.add_dependency(%q<rake>.freeze, ["~> 0.9"])
    s.add_dependency(%q<rspec>.freeze, ["~> 2.10"])
  end
end
