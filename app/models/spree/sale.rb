class Spree::Sale < ActiveRecord::Base
  has_many :discounts, foreign_key: :sale_id, dependent: :delete_all

  DISCOUNT_TYPES = {
    1 => 'Fixed',
    2 => 'Percentage'
  }

  default_value_for :is_active, false

  alias_attribute :active, :is_active

  accepts_nested_attributes_for :discounts, allow_destroy: true

  attr_accessible :is_active,
                  :sitewide,
                  :name,
                  :discount_size,
                  :discount_type,
                  :discounts_attributes,
                  :customisation_allowed

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

  scope :active, lambda { where(is_active: true) }

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

  def apply(price, surryhills)
    if fixed?
      discount_size < price ? price - discount_size : BigDecimal.new(0)
    elsif percentage?
      unless surryhills
        price * (BigDecimal.new(100) - discount_size) / 100
      else
        price * (BigDecimal.new(100) - 80) / 100
      end
    end
  end

  def mega_menu_image_url
    "//#{configatron.asset_host}/sale/#{name.downcase}.jpg"
  end

  def banner_images
    banner_images = {
      full:  'tile-sale-full.gif',
      small: 'tile-sale-sml.gif'
    }
    banner_images
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
    # "#{discount_string} OFF SITEWIDE. LIMITED TIME ONLY."
    "Let's go halvsies. 50% off your 2nd dress. LTO."
  end

  #HACK EOL 2015-12-22 MORE HACKS
  def sale_promo
    "HALFOFF"
  end

  class << self
    def active_sales_ids
      Spree::Sale.active.pluck(:id)
    end
  end
end
