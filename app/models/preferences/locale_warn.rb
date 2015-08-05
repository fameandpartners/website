module Preferences
  class LocaleWarn < Base
    attr_reader :site_version

    def initialize(site_version)
      @site_version = site_version
    end

    def long_text_key
      "#{site_version.code}_locale_warn_text"
    end

    def long_text
      preference_value(long_text_key)
    end
  end
end
