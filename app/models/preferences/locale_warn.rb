module Preferences
  class LocaleWarn
    attr_reader :site_version

    def initialize(site_version)
      @site_version = site_version

      create_preferences
    end

    def long_text_key
      "#{site_version.code}_locale_warn_text"
    end

    def long_text
      Spree::AppConfiguration.new[long_text_key]
    end

    private

    def create_preferences
      Spree::AppConfiguration.preference "#{site_version.code}_locale_warn_text" , :string, default: ''
    end
  end
end
