module Preferences
  class LocaleWarn < Base
    def long_text_key
      "#{site_version.code}_locale_warn_text"
    end

    def long_text
      preference_value(long_text_key)
    end
  end
end
