# -*- encoding: utf-8 -*-
# stub: sitemap_generator 5.0.5 ruby lib

Gem::Specification.new do |s|
  s.name = "sitemap_generator".freeze
  s.version = "5.0.5"

  s.required_rubygems_version = Gem::Requirement.new(">= 0".freeze) if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib".freeze]
  s.authors = ["Karl Varga".freeze]
  s.date = "2014-07-30"
  s.description = "SitemapGenerator is a framework-agnostic XML Sitemap generator written in Ruby with automatic Rails integration.  It supports Video, News, Image, Geo, Mobile, PageMap and Alternate Links sitemap extensions and includes Rake tasks for managing your sitemaps, as well as many other great features.".freeze
  s.email = "kjvarga@gmail.com".freeze
  s.homepage = "http://github.com/kjvarga/sitemap_generator".freeze
  s.licenses = ["MIT".freeze]
  s.post_install_message = "NOTE: SitemapGenerator 4.x uses a new file naming scheme which is more standards-compliant.\nIf you're upgrading from 3.x, please see the release note in the README:\n\nhttps://github.com/kjvarga/sitemap_generator#important-changes-in-version-4\n\nThe simple answer is that your index file is now called sitemap.xml.gz\nand not sitemap_index.xml.gz, but please take a look and see what else has changed.\n".freeze
  s.rubygems_version = "2.5.2".freeze
  s.summary = "Easily generate XML Sitemaps".freeze

  s.installed_by_version = "2.5.2" if s.respond_to? :installed_by_version

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_development_dependency(%q<mocha>.freeze, [">= 0"])
      s.add_development_dependency(%q<nokogiri>.freeze, [">= 0"])
      s.add_development_dependency(%q<rspec>.freeze, [">= 0"])
      s.add_runtime_dependency(%q<builder>.freeze, [">= 0"])
    else
      s.add_dependency(%q<mocha>.freeze, [">= 0"])
      s.add_dependency(%q<nokogiri>.freeze, [">= 0"])
      s.add_dependency(%q<rspec>.freeze, [">= 0"])
      s.add_dependency(%q<builder>.freeze, [">= 0"])
    end
  else
    s.add_dependency(%q<mocha>.freeze, [">= 0"])
    s.add_dependency(%q<nokogiri>.freeze, [">= 0"])
    s.add_dependency(%q<rspec>.freeze, [">= 0"])
    s.add_dependency(%q<builder>.freeze, [">= 0"])
  end
end
