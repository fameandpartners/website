# -*- encoding: utf-8 -*-
# stub: state_machine 1.1.2 ruby lib

Gem::Specification.new do |s|
  s.name = "state_machine".freeze
  s.version = "1.1.2"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Aaron Pfeifer".freeze]
  s.date = "2012-01-19"
  s.description = "Adds support for creating state machines for attributes on any Ruby class".freeze
  s.email = "aaron@pluginaweek.org".freeze
  s.extra_rdoc_files = ["README.md".freeze, "CHANGELOG.md".freeze, "LICENSE".freeze]
  s.files = ["CHANGELOG.md".freeze, "LICENSE".freeze, "README.md".freeze]
  s.homepage = "http://www.pluginaweek.org".freeze
  s.rdoc_options = ["--line-numbers".freeze, "--inline-source".freeze, "--title".freeze, "state_machine".freeze, "--main".freeze, "README.md".freeze]
  s.rubygems_version = "2.5.2".freeze
  s.summary = "State machines for attributes".freeze

  s.installed_by_version = "2.5.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<rake>.freeze, [">= 0"])
      s.add_development_dependency(%q<rcov>.freeze, [">= 0"])
      s.add_development_dependency(%q<appraisal>.freeze, ["~> 0.4.0"])
    else
      s.add_dependency(%q<rake>.freeze, [">= 0"])
      s.add_dependency(%q<rcov>.freeze, [">= 0"])
      s.add_dependency(%q<appraisal>.freeze, ["~> 0.4.0"])
    end
  else
    s.add_dependency(%q<rake>.freeze, [">= 0"])
    s.add_dependency(%q<rcov>.freeze, [">= 0"])
    s.add_dependency(%q<appraisal>.freeze, ["~> 0.4.0"])
  end
end
