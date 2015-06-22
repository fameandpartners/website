module Revolution
  class Translation < ActiveRecord::Base

    DEFAULT_LOCALE = 'en-US'

    attr_accessible :locale, :title, :meta_description

    validates :page, :locale, :title, :meta_description, :presence => true

    belongs_to :page

    def self.find_for_locale(locale)
      find_by_locale(locale) || find_for_default_locale
    end

    def self.find_for_default_locale
      find_by_locale(DEFAULT_LOCALE)
    end

  end

end
