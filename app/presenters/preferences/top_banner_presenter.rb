module Preferences
  class TopBannerPresenter
    attr_reader :preference

    def initialize(site_version)
      @preference = Preferences::TopBanner.new(site_version)
    end

    def right_text
      preference.right_text
    end

    def center_text
      preference.center_text
    end
  end
end
