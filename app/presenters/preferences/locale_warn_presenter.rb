module Preferences
  class LocaleWarnPresenter
    attr_reader :ip, :current_site_version, :session_site_version_code

    def initialize(opts = {})
      @ip                        = opts[:ip]
      @current_site_version      = opts[:current_site_version]
      @session_site_version_code = opts[:session_site_version_code]
    end

    def flag_url
      "flags/bigger/#{positional_site_version.code}.gif"
    end

    def button_text
      "Visit our #{positional_site_version.code.upcase} Store"
    end

    def long_text
      preference.long_text
    end

    # - Warning will show when:
    # -> User is from country that differs from current site version
    # -> User did not choose any the site version
    # -> User hasn't closed the alert
    def show?
      session_site_version_code.nil? && current_site_version != positional_site_version
    end

    private

    def positional_site_version
      FindUsersSiteVersion.new(request_ip: ip).sv_chosen_by_ip || SiteVersion.default
    end

    def preference
      Preferences::LocaleWarn.new(positional_site_version)
    end
  end
end