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
      self.locale ||= 'en-AU'
      self.currency ||= Spree::Config.currency
      self.exchange_rate ||= 1
      self.permalink ||= ''
      self.domain = 'au.lvh.me'
    end
  end

  def title
    code.capitalize
  end

  def abbr
    is_australia? ? 'aus' : 'usa'
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

  def size_settings
    @size_settings ||= begin
      if is_australia?
        OpenStruct.new({
          size_info_label: 'AUS Sizes Displayed',
          size_start: 4,
          size_charge_start: 18,
          size_end: 26,
          locale_code: 'au',
          locale_unit_code: 'cm',
          locale_unit_symbol: 'cm',
          currency_code: 'AUD'
        })
      else
        OpenStruct.new({
          size_info_label: 'US Sizes Displayed',
          size_start: 0,
          size_charge_start: 14,
          size_end: 22,
          locale_code: 'us',
          locale_unit_code: 'in',
          locale_unit_symbol: '&#8243;'.html_safe,
          currency_code: 'USD'
        })
      end
    end
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
      find_by_permalink(permalink) || default
    end

    def by_currency_or_default(currency)
      SiteVersion.where(currency: currency).first || SiteVersion.default
    end

    def default
      @default ||= self.where(default: true).first_or_initialize
    end

    def permalinks
      @permalinks ||= self.pluck(:permalink)
    end

    # NOTE  exchange rate 0.8 means 1 default currency == 0.8 site version currency
    # 0.8 =>  1AUD == 0.8USD
    #   get_exchange_rate(EUR, USD) => is EUR -> AUD -> USD
    #   base / rate_to_default_currency * rate_to_required_currency
    def get_exchange_rate(from, to)
      rate_to_default_currency = (from == Spree::Config.currency) ? 1.0 : currency_rates[from]
      rate_to_required_currency = currency_rates[to]

      return (1.0 / rate_to_default_currency) * rate_to_required_currency
    rescue Exception => e
      1.0
    end

    def currency_rates
      @exchange_rates ||= begin
        result = HashWithIndifferentAccess.new(){ 1.0 }
        SiteVersion.all.each do |site_version|
          result[site_version.currency] = site_version.exchange_rate.to_f
        end
        result
      end
    end
  end
end
