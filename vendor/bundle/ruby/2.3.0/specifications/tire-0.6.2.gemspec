# -*- encoding: utf-8 -*-
# stub: tire 0.6.2 ruby lib

Gem::Specification.new do |s|
  s.name = "tire".freeze
  s.version = "0.6.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.3.6".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Karel Minarik".freeze]
  s.date = "2014-01-15"
  s.description = "   Tire is a Ruby client for the Elasticsearch search engine/database.\n\n   It provides Ruby-like API for fluent communication with the Elasticsearch server\n   and blends with ActiveModel class for convenient usage in Rails applications.\n\n   It allows to delete and create indices, define mapping for them, supports\n   the bulk API, and presents an easy-to-use DSL for constructing your queries.\n\n   It has full ActiveRecord/ActiveModel compatibility, allowing you to index\n   your models (incrementally upon saving, or in bulk), searching and\n   paginating the results.\n\n   Please check the documentation at <http://karmi.github.com/retire/>.\n".freeze
  s.email = "karmi@karmi.cz".freeze
  s.extra_rdoc_files = ["README.markdown".freeze, "MIT-LICENSE".freeze]
  s.files = ["MIT-LICENSE".freeze, "README.markdown".freeze]
  s.homepage = "http://github.com/karmi/tire".freeze
  s.post_install_message = "================================================================================\n\n  Please check the documentation at <http://karmi.github.com/retire/>.\n\n--------------------------------------------------------------------------------\n\n  IMPORTANT CHANGES LATELY:\n\n  19e524c [ACTIVEMODEL] Exposed the response from `MyModel#.update_index` as the `response` method on return value\n  bfcde21 [#916] Added support for the Suggest API (@marc-villanueva)\n  710451d [#857] Added support for the Suggest API (@fbatista)\n\n  See the full changelog at <http://github.com/karmi/tire/commits/v0.6.2>.\n\n--------------------------------------------------------------------------------\n".freeze
  s.rdoc_options = ["--charset=UTF-8".freeze]
  s.rubyforge_project = "tire".freeze
  s.rubygems_version = "2.5.2".freeze
  s.summary = "Ruby client for Elasticsearch".freeze

  s.installed_by_version = "2.5.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<rake>.freeze, [">= 0"])
      s.add_runtime_dependency(%q<rest-client>.freeze, ["~> 1.6"])
      s.add_runtime_dependency(%q<multi_json>.freeze, ["~> 1.3"])
      s.add_runtime_dependency(%q<activemodel>.freeze, [">= 3.0"])
      s.add_runtime_dependency(%q<hashr>.freeze, ["~> 0.0.19"])
      s.add_runtime_dependency(%q<activesupport>.freeze, [">= 0"])
      s.add_runtime_dependency(%q<ansi>.freeze, [">= 0"])
      s.add_development_dependency(%q<bundler>.freeze, ["~> 1.0"])
      s.add_development_dependency(%q<shoulda-context>.freeze, [">= 0"])
      s.add_development_dependency(%q<mocha>.freeze, ["~> 0.13"])
      s.add_development_dependency(%q<minitest>.freeze, ["~> 2.12"])
      s.add_development_dependency(%q<activerecord>.freeze, [">= 3.0"])
      s.add_development_dependency(%q<active_model_serializers>.freeze, [">= 0"])
      s.add_development_dependency(%q<mongoid>.freeze, ["~> 2.2"])
      s.add_development_dependency(%q<redis-persistence>.freeze, [">= 0"])
      s.add_development_dependency(%q<faraday>.freeze, [">= 0"])
      s.add_development_dependency(%q<yajl-ruby>.freeze, ["~> 1.0"])
      s.add_development_dependency(%q<sqlite3>.freeze, [">= 0"])
      s.add_development_dependency(%q<bson_ext>.freeze, [">= 0"])
      s.add_development_dependency(%q<curb>.freeze, [">= 0"])
      s.add_development_dependency(%q<oj>.freeze, [">= 0"])
      s.add_development_dependency(%q<turn>.freeze, ["~> 0.9"])
    else
      s.add_dependency(%q<rake>.freeze, [">= 0"])
      s.add_dependency(%q<rest-client>.freeze, ["~> 1.6"])
      s.add_dependency(%q<multi_json>.freeze, ["~> 1.3"])
      s.add_dependency(%q<activemodel>.freeze, [">= 3.0"])
      s.add_dependency(%q<hashr>.freeze, ["~> 0.0.19"])
      s.add_dependency(%q<activesupport>.freeze, [">= 0"])
      s.add_dependency(%q<ansi>.freeze, [">= 0"])
      s.add_dependency(%q<bundler>.freeze, ["~> 1.0"])
      s.add_dependency(%q<shoulda-context>.freeze, [">= 0"])
      s.add_dependency(%q<mocha>.freeze, ["~> 0.13"])
      s.add_dependency(%q<minitest>.freeze, ["~> 2.12"])
      s.add_dependency(%q<activerecord>.freeze, [">= 3.0"])
      s.add_dependency(%q<active_model_serializers>.freeze, [">= 0"])
      s.add_dependency(%q<mongoid>.freeze, ["~> 2.2"])
      s.add_dependency(%q<redis-persistence>.freeze, [">= 0"])
      s.add_dependency(%q<faraday>.freeze, [">= 0"])
      s.add_dependency(%q<yajl-ruby>.freeze, ["~> 1.0"])
      s.add_dependency(%q<sqlite3>.freeze, [">= 0"])
      s.add_dependency(%q<bson_ext>.freeze, [">= 0"])
      s.add_dependency(%q<curb>.freeze, [">= 0"])
      s.add_dependency(%q<oj>.freeze, [">= 0"])
      s.add_dependency(%q<turn>.freeze, ["~> 0.9"])
    end
  else
    s.add_dependency(%q<rake>.freeze, [">= 0"])
    s.add_dependency(%q<rest-client>.freeze, ["~> 1.6"])
    s.add_dependency(%q<multi_json>.freeze, ["~> 1.3"])
    s.add_dependency(%q<activemodel>.freeze, [">= 3.0"])
    s.add_dependency(%q<hashr>.freeze, ["~> 0.0.19"])
    s.add_dependency(%q<activesupport>.freeze, [">= 0"])
    s.add_dependency(%q<ansi>.freeze, [">= 0"])
    s.add_dependency(%q<bundler>.freeze, ["~> 1.0"])
    s.add_dependency(%q<shoulda-context>.freeze, [">= 0"])
    s.add_dependency(%q<mocha>.freeze, ["~> 0.13"])
    s.add_dependency(%q<minitest>.freeze, ["~> 2.12"])
    s.add_dependency(%q<activerecord>.freeze, [">= 3.0"])
    s.add_dependency(%q<active_model_serializers>.freeze, [">= 0"])
    s.add_dependency(%q<mongoid>.freeze, ["~> 2.2"])
    s.add_dependency(%q<redis-persistence>.freeze, [">= 0"])
    s.add_dependency(%q<faraday>.freeze, [">= 0"])
    s.add_dependency(%q<yajl-ruby>.freeze, ["~> 1.0"])
    s.add_dependency(%q<sqlite3>.freeze, [">= 0"])
    s.add_dependency(%q<bson_ext>.freeze, [">= 0"])
    s.add_dependency(%q<curb>.freeze, [">= 0"])
    s.add_dependency(%q<oj>.freeze, [">= 0"])
    s.add_dependency(%q<turn>.freeze, ["~> 0.9"])
  end
end
