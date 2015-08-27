module Preferences
  class SEO < Base
    def default_seo_title_key
      "#{site_version.code}_default_seo_title"
    end

    def default_meta_description_key
      "#{site_version.code}_default_meta_description"
    end

    def default_seo_title
      preference_value(default_seo_title_key)
    end

    def default_meta_description
      preference_value(default_meta_description_key)
    end
  end
end
