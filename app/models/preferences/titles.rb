module Preferences
  class Titles < Base
    def homepage_title_key
      "#{site_version.code}_homepage_title"
    end

    def default_seo_title_key
      "#{site_version.code}_default_seo_title"
    end

    def homepage_title
      preference_value(homepage_title_key)
    end

    def default_seo_title
      preference_value(default_seo_title_key)
    end
  end
end
