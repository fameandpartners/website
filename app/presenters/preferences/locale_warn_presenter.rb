module Preferences
  class LocaleWarnPresenter
    attr_reader :current_site_version, :geo_site_version, :session_site_version_code

    def initialize(opts = {})
      @geo_site_version          = opts[:geo_site_version]
      @current_site_version      = opts[:current_site_version]
      @session_site_version_code = opts[:session_site_version_code]
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

    # - Warning will show when:
    # -> User is from country that differs from current site version
    # -> User did not choose any the site version
    # -> User hasn't closed the alert
    def show?
      session_site_version_code.nil? && current_site_version != geo_site_version
    end

    private

    def preference
      Preferences::LocaleWarn.new(geo_site_version)
    end
  end
end