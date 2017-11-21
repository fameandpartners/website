# -*- encoding: utf-8 -*-
# stub: uglifier 1.3.0 ruby lib

Gem::Specification.new do |s|
  s.name = "uglifier".freeze
  s.version = "1.3.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Ville Lautanala".freeze]
  s.date = "2012-09-02"
  s.email = "lautis@gmail.com".freeze
  s.extra_rdoc_files = ["LICENSE.txt".freeze, "README.md".freeze]
  s.files = ["LICENSE.txt".freeze, "README.md".freeze]
  s.homepage = "http://github.com/lautis/uglifier".freeze
  s.rubygems_version = "2.5.2".freeze
  s.summary = "Ruby wrapper for UglifyJS JavaScript compressor".freeze

  s.installed_by_version = "2.5.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<execjs>.freeze, [">= 0.3.0"])
      s.add_runtime_dependency(%q<multi_json>.freeze, [">= 1.0.2", "~> 1.0"])
      s.add_development_dependency(%q<rspec>.freeze, ["~> 2.7"])
      s.add_development_dependency(%q<bundler>.freeze, ["~> 1.0"])
      s.add_development_dependency(%q<jeweler>.freeze, ["~> 1.8.3"])
      s.add_development_dependency(%q<rdoc>.freeze, ["~> 3.11"])
    else
      s.add_dependency(%q<execjs>.freeze, [">= 0.3.0"])
      s.add_dependency(%q<multi_json>.freeze, [">= 1.0.2", "~> 1.0"])
      s.add_dependency(%q<rspec>.freeze, ["~> 2.7"])
      s.add_dependency(%q<bundler>.freeze, ["~> 1.0"])
      s.add_dependency(%q<jeweler>.freeze, ["~> 1.8.3"])
      s.add_dependency(%q<rdoc>.freeze, ["~> 3.11"])
    end
  else
    s.add_dependency(%q<execjs>.freeze, [">= 0.3.0"])
    s.add_dependency(%q<multi_json>.freeze, [">= 1.0.2", "~> 1.0"])
    s.add_dependency(%q<rspec>.freeze, ["~> 2.7"])
    s.add_dependency(%q<bundler>.freeze, ["~> 1.0"])
    s.add_dependency(%q<jeweler>.freeze, ["~> 1.8.3"])
    s.add_dependency(%q<rdoc>.freeze, ["~> 3.11"])
  end
end
