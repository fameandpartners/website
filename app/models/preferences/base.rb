module Preferences
  class Base
    attr_reader :site_version

    def initialize(site_version)
      @site_version = site_version
    end

    def preference_value(key)
      Spree::Config[key] if Spree::Config.has_preference?(key)
    end
  end
end
