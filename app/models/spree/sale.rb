class Spree::Sale < ActiveRecord::Base
  has_many :discounts, foreign_key: :sale_id, dependent: :delete_all

  DISCOUNT_TYPES = {
    1 => 'Fixed',
    2 => 'Percentage'
  }.freeze

  default_value_for :is_active, false

  alias_attribute :active, :is_active

  accepts_nested_attributes_for :discounts, allow_destroy: true

  attr_accessible :is_active,
                  :sitewide,
                  :sitewide_message,
                  :name,
                  :discount_size,
                  :discount_type,
                  :discounts_attributes,
                  :customisation_allowed,
                  :currency

  validates :is_active,
            :inclusion => {
              :in => [true, false]
            }
  validates :discount_type,
            :presence => true,
            :inclusion => {
              :in => DISCOUNT_TYPES.keys
            }
  validates :discount_size,
            :numericality => {
              :greater_than_or_equal_to => 0
            }

  validates :sitewide_message,
            presence: true,
            length: { minimum: 5 }

  validates :currency,
            inclusion: { in: -> (currency) { SiteVersion.pluck(:currency) } },
            allow_blank: true

  scope :active,   -> { where(is_active: true) }
  scope :sitewide, -> { where(sitewide: true) }
  scope :for_currency, -> (currency) { where("lower(currency) = ? OR currency = ''", currency.to_s.downcase) }

  has_many :discounts

  DISCOUNT_TYPES.each do |id, name|
    define_method "#{name.downcase}?" do
      self.discount_type.eql?(id)
    end
  end

  # base discount for all child items
  def discount
    Discount.new(amount: discount_size.to_i)
  end

  def explanation
    "Sale - Up to #{discount_string} Off"
  end

  def discount_string
    if percentage?
      "#{discount_size.to_i}%"
    else
      "$#{discount_size.to_i}"
    end
  end

  def sitewide_message
    super.to_s.gsub(/{discount}/, discount_string)
  end

  def self.last_sitewide_for(currency: currency)
    active.sitewide.order('created_at DESC').limit(1).for_currency(currency).last
  end

end
