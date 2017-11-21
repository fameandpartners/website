# -*- encoding: utf-8 -*-
# stub: launchy 2.2.0 ruby lib

Gem::Specification.new do |s|
  s.name = "launchy".freeze
  s.version = "2.2.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Jeremy Hinegardner".freeze]
  s.date = "2013-02-06"
  s.description = "Launchy is helper class for launching cross-platform applications in a fire and forget manner. There are application concepts (browser, email client, etc) that are common across all platforms, and they may be launched differently on each platform. Launchy is here to make a common approach to launching external application from within ruby programs.".freeze
  s.email = "jeremy@copiousfreetime.org".freeze
  s.executables = ["launchy".freeze]
  s.extra_rdoc_files = ["HISTORY.rdoc".freeze, "Manifest.txt".freeze, "README.rdoc".freeze]
  s.files = ["HISTORY.rdoc".freeze, "Manifest.txt".freeze, "README.rdoc".freeze, "bin/launchy".freeze]
  s.homepage = "http://github.com/copiousfreetime/launchy".freeze
  s.rdoc_options = ["--main".freeze, "README.rdoc".freeze, "--markup".freeze, "tomdoc".freeze]
  s.rubygems_version = "2.5.2".freeze
  s.summary = "Launchy is helper class for launching cross-platform applications in a fire and forget manner.".freeze

  s.installed_by_version = "2.5.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<addressable>.freeze, ["~> 2.3"])
      s.add_development_dependency(%q<rake>.freeze, ["~> 10.0.3"])
      s.add_development_dependency(%q<minitest>.freeze, ["~> 4.5.0"])
      s.add_development_dependency(%q<rdoc>.freeze, ["~> 3.12"])
    else
      s.add_dependency(%q<addressable>.freeze, ["~> 2.3"])
      s.add_dependency(%q<rake>.freeze, ["~> 10.0.3"])
      s.add_dependency(%q<minitest>.freeze, ["~> 4.5.0"])
      s.add_dependency(%q<rdoc>.freeze, ["~> 3.12"])
    end
  else
    s.add_dependency(%q<addressable>.freeze, ["~> 2.3"])
    s.add_dependency(%q<rake>.freeze, ["~> 10.0.3"])
    s.add_dependency(%q<minitest>.freeze, ["~> 4.5.0"])
    s.add_dependency(%q<rdoc>.freeze, ["~> 3.12"])
  end
end
