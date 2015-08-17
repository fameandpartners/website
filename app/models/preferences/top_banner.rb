module Preferences
  class TopBanner < Base
    attr_reader :site_version

    def initialize(site_version)
      @site_version = site_version
    end

    # Not using meta programming until we have more positions
    def right_text_key
      "#{site_version.code}_top_banner_right_text"
    end

    def center_text_key
      "#{site_version.code}_top_banner_center_text"
    end

    def right_text
      preference_value(right_text_key)
    end

    def center_text
      preference_value(center_text_key)
    end
  end
end
