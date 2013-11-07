class SiteVersion < ActiveRecord::Base
  belongs_to :zone, class_name: 'Spree::Zone'

  validates :zone, presence: true
  validates :name, presence: true
  validates :permalink, allow_blank: true, uniqueness: { case_sensitive: false }

  attr_accessible :name, :permalink, :zone_id, :currency, :locale, :default

  after_initialize :set_default_values

  def set_default_values
    if self.new_record?
      self.name ||= 'USA'
      self.locale ||= 'en_US'
      self.currency ||= 'USD'
      self.permalink ||= ''
    end
  end

  def is_australia?
    permalink.to_s.downcase.gsub(/\W/, '') == 'au'
  end

  def code
    @code ||= permalink.to_s.downcase.gsub(/\W/, '')
  end

  class << self
    def by_permalink_or_default(permalink)
      version = nil
      if permalink.present?
        permalink.to_s.gsub!(/\W/, '')
        version = SiteVersion.where(permalink: permalink).first
      end
      version || SiteVersion.default
    end

    def by_country_code_or_default(country_code)
      country_code ||= 'us'
      country = Spree::Country.where(iso: country_code.upcase).first
      site_version = nil
      if country.present?
        zones_ids = Spree::ZoneMember.where(
          zoneable_id: country.id, zoneable_type: "Spree::Country"
        ).select(:zone_id).map(&:zone_id)
        site_version = SiteVersion.where(zone_id: zones_ids).first
      end

      site_version || SiteVersion.default
    end

    def default
      self.where(default: true).first_or_initialize
    end
  end
end
