class SiteVersion < ActiveRecord::Base
  belongs_to :zone, class_name: 'Spree::Zone'

  validates :zone, presence: true
  validates :name, presence: true
  validates :permalink, presence: true, uniqueness: { case_sensitive: false }

  attr_accessible :name, :permalink, :zone_id, :currency, :locale, :default

  def is_australia?
    permalink.to_s.downcase.gsub(/\W/, '') == 'au'
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

    def default
      self.where(default: true).first_or_initialize
    end
  end
end
