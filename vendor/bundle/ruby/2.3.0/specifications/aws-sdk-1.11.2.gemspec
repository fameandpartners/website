# -*- encoding: utf-8 -*-
# stub: aws-sdk 1.11.2 ruby lib

Gem::Specification.new do |s|
  s.name = "aws-sdk".freeze
  s.version = "1.11.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Amazon Web Services".freeze]
  s.date = "2013-06-09"
  s.description = "AWS SDK for Ruby".freeze
  s.homepage = "http://aws.amazon.com/sdkforruby".freeze
  s.licenses = ["Apache 2.0".freeze]
  s.rubygems_version = "2.5.2".freeze
  s.summary = "AWS SDK for Ruby".freeze

  s.installed_by_version = "2.5.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<uuidtools>.freeze, ["~> 2.1"])
      s.add_runtime_dependency(%q<nokogiri>.freeze, ["< 1.6.0"])
      s.add_runtime_dependency(%q<json>.freeze, ["~> 1.4"])
    else
      s.add_dependency(%q<uuidtools>.freeze, ["~> 2.1"])
      s.add_dependency(%q<nokogiri>.freeze, ["< 1.6.0"])
      s.add_dependency(%q<json>.freeze, ["~> 1.4"])
    end
  else
    s.add_dependency(%q<uuidtools>.freeze, ["~> 2.1"])
    s.add_dependency(%q<nokogiri>.freeze, ["< 1.6.0"])
    s.add_dependency(%q<json>.freeze, ["~> 1.4"])
  end
end
