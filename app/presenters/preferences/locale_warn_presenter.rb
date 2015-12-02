module Preferences
  class LocaleWarnPresenter
    include SiteVersionRoutingHelper

    attr_reader :current_site_version, :geo_site_version, :session_site_version_code, :request_url

    def initialize(opts = {})
      @request_url               = opts[:request_url]
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

    def geo_site_version_url
      site_version_url(request_url, geo_site_version)
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

    def cache_key
      request_url_digest = Digest::MD5.hexdigest(request_url)
      [request_url_digest, geo_site_version.code, current_site_version.code, show?].join('-')
    end

    private

    def preference
      Preferences::LocaleWarn.new(geo_site_version)
    end
  end
end
