module Preferences
  class TopBanner
    attr_reader :site_version

    def initialize(site_version)
      @site_version = site_version
      create_preferences
    end

    # Not using meta programming until we have more positions
    def right_text_key
      "#{site_version.code}_top_banner_right_text"
    end

    def center_text_key
      "#{site_version.code}_top_banner_center_text"
    end

    def right_text
      Spree::AppConfiguration.new[right_text_key]
    end

    def center_text
      Spree::AppConfiguration.new[center_text_key]
    end

    private

    def create_preferences
      Spree::AppConfiguration.preference right_text_key , :string, default: ''
      Spree::AppConfiguration.preference center_text_key, :string, default: ''
    end
  end
end