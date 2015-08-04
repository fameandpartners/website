module Preferences
  class Titles
    attr_reader :site_version

    def initialize(site_version)
      @site_version = site_version
    end

    def homepage_title_key
      "#{site_version.code}_homepage_title"
    end

    def default_seo_title_key
      "#{site_version.code}_default_seo_title"
    end

    def homepage_title
      Spree::Config[homepage_title_key]
    end

    def default_seo_title
      Spree::Config[default_seo_title_key]
    end
  end
end
