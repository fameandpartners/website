module Revolution
  class Translation < ActiveRecord::Base

    DEFAULT_LOCALE = 'en-US'

    attr_accessible :banners_attributes, :locale, :title, :meta_description, :heading, :sub_heading, :description, :page

    validates :page, :locale, :title, :meta_description, presence: true

    belongs_to :page, inverse_of: :translations

    has_many :banners, dependent: :destroy, inverse_of: :translation

    accepts_nested_attributes_for :banners, reject_if: :all_blank

    def self.find_for_locale(locale = nil)
      locale ||= Translation::DEFAULT_LOCALE
      find_by_locale(locale) || find_for_default_locale
    end

    def self.find_for_default_locale
      find_by_locale(DEFAULT_LOCALE)
    end

    def self.get_banner_for_pos(local_locale, position, size)
      find_for_locale(local_locale).banners.banner_pos(position, size)
    end

    def self.other_locale(local_locale)
      where('locale != ?', local_locale).first.locale
    end

    def self.banner_count(local_locale)
      find_for_locale(local_locale).banners.count
    end

    def banner?(size)
      banners.banner_present(size)
    end

  end

end
