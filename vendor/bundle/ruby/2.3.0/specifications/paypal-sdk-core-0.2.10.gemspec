# -*- encoding: utf-8 -*-
# stub: paypal-sdk-core 0.2.10 ruby lib

Gem::Specification.new do |s|
  s.name = "paypal-sdk-core".freeze
  s.version = "0.2.10"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["PayPal".freeze]
  s.date = "2014-06-25"
  s.description = "Core library for PayPal ruby SDKs".freeze
  s.email = ["DL-PP-Platform-Ruby-SDK@ebay.com".freeze]
  s.homepage = "https://developer.paypal.com".freeze
  s.licenses = ["PayPal SDK License".freeze]
  s.rubygems_version = "2.5.2".freeze
  s.summary = "Core library for PayPal ruby SDKs".freeze

  s.installed_by_version = "2.5.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<xml-simple>.freeze, [">= 0"])
      s.add_runtime_dependency(%q<multi_json>.freeze, ["~> 1.0"])
    else
      s.add_dependency(%q<xml-simple>.freeze, [">= 0"])
      s.add_dependency(%q<multi_json>.freeze, ["~> 1.0"])
    end
  else
    s.add_dependency(%q<xml-simple>.freeze, [">= 0"])
    s.add_dependency(%q<multi_json>.freeze, ["~> 1.0"])
  end
end
