# -*- encoding: utf-8 -*-
# stub: google_drive 1.0.0 ruby lib

Gem::Specification.new do |s|
  s.name = "google_drive".freeze
  s.version = "1.0.0"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Hiroshi Ichikawa".freeze]
  s.date = "2014-12-25"
  s.description = "A library to read/write files/spreadsheets in Google Drive/Docs.".freeze
  s.email = ["gimite+github@gmail.com".freeze]
  s.extra_rdoc_files = ["README.rdoc".freeze, "doc_src/google_drive/acl.rb".freeze]
  s.files = ["README.rdoc".freeze, "doc_src/google_drive/acl.rb".freeze]
  s.homepage = "https://github.com/gimite/google-drive-ruby".freeze
  s.licenses = ["New BSD".freeze]
  s.rdoc_options = ["--main".freeze, "README.rdoc".freeze]
  s.rubygems_version = "2.5.2".freeze
  s.summary = "A library to read/write files/spreadsheets in Google Drive/Docs.".freeze

  s.installed_by_version = "2.5.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<nokogiri>.freeze, ["!= 1.5.1", "!= 1.5.2", ">= 1.4.4"])
      s.add_runtime_dependency(%q<oauth>.freeze, [">= 0.3.6"])
      s.add_runtime_dependency(%q<oauth2>.freeze, [">= 0.5.0"])
      s.add_runtime_dependency(%q<google-api-client>.freeze, [">= 0.7.0"])
      s.add_development_dependency(%q<rake>.freeze, [">= 0.8.0"])
    else
      s.add_dependency(%q<nokogiri>.freeze, ["!= 1.5.1", "!= 1.5.2", ">= 1.4.4"])
      s.add_dependency(%q<oauth>.freeze, [">= 0.3.6"])
      s.add_dependency(%q<oauth2>.freeze, [">= 0.5.0"])
      s.add_dependency(%q<google-api-client>.freeze, [">= 0.7.0"])
      s.add_dependency(%q<rake>.freeze, [">= 0.8.0"])
    end
  else
    s.add_dependency(%q<nokogiri>.freeze, ["!= 1.5.1", "!= 1.5.2", ">= 1.4.4"])
    s.add_dependency(%q<oauth>.freeze, [">= 0.3.6"])
    s.add_dependency(%q<oauth2>.freeze, [">= 0.5.0"])
    s.add_dependency(%q<google-api-client>.freeze, [">= 0.7.0"])
    s.add_dependency(%q<rake>.freeze, [">= 0.8.0"])
  end
end
