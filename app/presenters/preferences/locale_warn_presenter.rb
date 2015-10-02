module Preferences
  class LocaleWarnPresenter
    attr_reader :current_site_version, :geo_site_version, :close_warning

    def initialize(geo_site_version: nil, current_site_version: nil, close_warning: false)
      @close_warning        = close_warning
      @current_site_version = current_site_version
      @geo_site_version     = geo_site_version
    end

    def flag_url
      "flags/bigger/#{geo_site_version.code}.gif"
    end

    def button_text
      "Visit our #{geo_site_version.code} Store"
    end

    def site_version_path
      Rails.application.routes.url_helpers.site_version_path(id: geo_site_version.code)
    end

    def long_text
      preference.long_text
    end

    def show?
      !close_warning && current_site_version != geo_site_version
    end

    def cache_key
      [geo_site_version.code, current_site_version.code, show?].join('-')
    end

    private

    def preference
      Preferences::LocaleWarn.new(geo_site_version)
    end
  end
end
