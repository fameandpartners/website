# -*- encoding: utf-8 -*-
# stub: mumboe-soap4r 1.5.8.7 ruby lib

Gem::Specification.new do |s|
  s.name = "mumboe-soap4r".freeze
  s.version = "1.5.8.7"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Scott Diedrick (modifier: swalterd)".freeze]
  s.date = "2013-12-01"
  s.email = "swalterd@gmail.com".freeze
  s.executables = ["wsdl2ruby.rb".freeze, "xsd2ruby.rb".freeze]
  s.files = ["bin/wsdl2ruby.rb".freeze, "bin/xsd2ruby.rb".freeze]
  s.homepage = "https://github.com/mumboe/soap4r".freeze
  s.rubygems_version = "2.5.2".freeze
  s.summary = "An implementation of SOAP 1.1 for Ruby.".freeze

  s.installed_by_version = "2.5.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<httpclient>.freeze, [">= 2.1.1"])
    else
      s.add_dependency(%q<httpclient>.freeze, [">= 2.1.1"])
    end
  else
    s.add_dependency(%q<httpclient>.freeze, [">= 2.1.1"])
  end
end
