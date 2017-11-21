# -*- encoding: utf-8 -*-
# stub: paperclip 2.8.0 ruby lib

Gem::Specification.new do |s|
  s.name = "paperclip".freeze
  s.version = "2.8.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Jon Yurek".freeze]
  s.date = "2012-10-07"
  s.description = "Easy upload management for ActiveRecord".freeze
  s.email = ["jyurek@thoughtbot.com".freeze]
  s.homepage = "https://github.com/thoughtbot/paperclip".freeze
  s.requirements = ["ImageMagick".freeze]
  s.rubyforge_project = "paperclip".freeze
  s.rubygems_version = "2.5.2".freeze
  s.summary = "File attachments as attributes for ActiveRecord".freeze

  s.installed_by_version = "2.5.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activerecord>.freeze, [">= 2.3.0"])
      s.add_runtime_dependency(%q<activesupport>.freeze, [">= 2.3.2"])
      s.add_runtime_dependency(%q<cocaine>.freeze, [">= 0.0.2"])
      s.add_runtime_dependency(%q<mime-types>.freeze, [">= 0"])
      s.add_development_dependency(%q<shoulda>.freeze, [">= 0"])
      s.add_development_dependency(%q<appraisal>.freeze, ["~> 0.4.0"])
      s.add_development_dependency(%q<mocha>.freeze, [">= 0"])
      s.add_development_dependency(%q<aws-sdk>.freeze, [">= 0"])
      s.add_development_dependency(%q<sqlite3>.freeze, ["~> 1.3.5"])
      s.add_development_dependency(%q<cucumber>.freeze, ["~> 1.1.0"])
      s.add_development_dependency(%q<aruba>.freeze, [">= 0"])
      s.add_development_dependency(%q<capybara>.freeze, [">= 0"])
      s.add_development_dependency(%q<bundler>.freeze, [">= 0"])
      s.add_development_dependency(%q<cocaine>.freeze, ["~> 0.4.0"])
      s.add_development_dependency(%q<fog>.freeze, [">= 0"])
      s.add_development_dependency(%q<rake>.freeze, [">= 0"])
      s.add_development_dependency(%q<fakeweb>.freeze, [">= 0"])
    else
      s.add_dependency(%q<activerecord>.freeze, [">= 2.3.0"])
      s.add_dependency(%q<activesupport>.freeze, [">= 2.3.2"])
      s.add_dependency(%q<cocaine>.freeze, [">= 0.0.2"])
      s.add_dependency(%q<mime-types>.freeze, [">= 0"])
      s.add_dependency(%q<shoulda>.freeze, [">= 0"])
      s.add_dependency(%q<appraisal>.freeze, ["~> 0.4.0"])
      s.add_dependency(%q<mocha>.freeze, [">= 0"])
      s.add_dependency(%q<aws-sdk>.freeze, [">= 0"])
      s.add_dependency(%q<sqlite3>.freeze, ["~> 1.3.5"])
      s.add_dependency(%q<cucumber>.freeze, ["~> 1.1.0"])
      s.add_dependency(%q<aruba>.freeze, [">= 0"])
      s.add_dependency(%q<capybara>.freeze, [">= 0"])
      s.add_dependency(%q<bundler>.freeze, [">= 0"])
      s.add_dependency(%q<cocaine>.freeze, ["~> 0.4.0"])
      s.add_dependency(%q<fog>.freeze, [">= 0"])
      s.add_dependency(%q<rake>.freeze, [">= 0"])
      s.add_dependency(%q<fakeweb>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<activerecord>.freeze, [">= 2.3.0"])
    s.add_dependency(%q<activesupport>.freeze, [">= 2.3.2"])
    s.add_dependency(%q<cocaine>.freeze, [">= 0.0.2"])
    s.add_dependency(%q<mime-types>.freeze, [">= 0"])
    s.add_dependency(%q<shoulda>.freeze, [">= 0"])
    s.add_dependency(%q<appraisal>.freeze, ["~> 0.4.0"])
    s.add_dependency(%q<mocha>.freeze, [">= 0"])
    s.add_dependency(%q<aws-sdk>.freeze, [">= 0"])
    s.add_dependency(%q<sqlite3>.freeze, ["~> 1.3.5"])
    s.add_dependency(%q<cucumber>.freeze, ["~> 1.1.0"])
    s.add_dependency(%q<aruba>.freeze, [">= 0"])
    s.add_dependency(%q<capybara>.freeze, [">= 0"])
    s.add_dependency(%q<bundler>.freeze, [">= 0"])
    s.add_dependency(%q<cocaine>.freeze, ["~> 0.4.0"])
    s.add_dependency(%q<fog>.freeze, [">= 0"])
    s.add_dependency(%q<rake>.freeze, [">= 0"])
    s.add_dependency(%q<fakeweb>.freeze, [">= 0"])
  end
end
