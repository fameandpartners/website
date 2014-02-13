class SiteVersion < ActiveRecord::Base
  belongs_to :zone, class_name: 'Spree::Zone'

  validates :zone, presence: true
  validates :name, presence: true
  validates :permalink, presence: true, uniqueness: { case_sensitive: false }

  validates :exchange_rate,
    numericality: { greater_than: 0.1, less_than: 10 }

  attr_accessible :name, :permalink, :zone_id, :currency, :locale, :default

  after_initialize :set_default_values

  def to_param
    self.default? ? '' : self.code
  end

  def set_default_values
    if self.new_record?
      self.name ||= 'Australia'
      self.locale ||= 'en_AU'
      self.currency ||= Spree::Config.currency
      self.exchange_rate ||= 1
      self.permalink ||= ''
    end
  end

  def is_australia?
    code == 'au'
  end

  def is_usa?
    code == 'us'
  end

  def code
    permalink.to_s.downcase.gsub(/\W/, '')
  end

  def countries
    if self.zone
      country_ids = zone.zone_members.where(zoneable_type: "Spree::Country").collect(&:zoneable_id)
      Spree::Country.where(id: country_ids)
    else
      Spree::Country.all
    end
  rescue
    Spree::Country.all
  end

  def default_country
    Spree::Country.where("lower(iso) = ?", self.code).first
  end

  def update_exchange_rate(rate = nil, options = {})
    if self.currency == Spree::Config.currency 
      puts "site version uses default currency"
      return true
    end

    if !options[:force] && self.exchange_rate_timestamp && self.exchange_rate_timestamp >= Date.today
      puts "prices already updated"
      return true
    end

    rate ||= Products::CurrencyConverter.get_rate(default_currency, self.currency)

    if rate.present?
      self.exchange_rate           = rate
      self.exchange_rate_timestamp = Date.today
      if self.exchange_rate_changed?
        if save
          create_or_update_prices
        end
      end
    end
  end

  def create_or_update_prices
    if self.currency == Spree::Config.currency or self.exchange_rate.blank?
      return true
    end

    Spree::Product.includes(:master).all.each do |product|
      product.add_price_conversion(self.currency, self.exchange_rate)
    end
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

    def by_currency_or_default(currency)
      SiteVersion.where(currency: currency).first || SiteVersion.default
    end

    def default
      @default ||= self.where(default: true).first_or_initialize
    end

    # NOTE  exchange rate 0.8 means 1 default currency == 0.8 site version currency
    # 0.8 =>  1AUD == 0.8USD
    #   get_exchange_rate(EUR, USD) => is EUR -> AUD -> USD
    #   base / rate_to_default_currency * rate_to_required_currency
    def get_exchange_rate(from, to)
      if from == Spree::Config.currency
        rate_to_default_currency = 1
      else
        rate_to_default_currency = SiteVersion.where(currency: from).first.try(:exchange_rate) || 1
      end
      rate_to_required_currency = SiteVersion.where(currency: to).first.try(:exchange_rate) || 1

      return (1.0 / rate_to_default_currency) * rate_to_required_currency
    rescue Exception => e
      1
    end
  end
end
