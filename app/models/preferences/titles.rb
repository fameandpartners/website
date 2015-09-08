module Preferences
  class Titles < Base
    def homepage_title_key
      "#{site_version.code}_homepage_title"
    end

    def homepage_title
      preference_value(homepage_title_key)
    end
  end
end
