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

  validates :sitewide_message,
            presence: true,
            length: { minimum: 5 }

  scope :active,   -> { where(is_active: true) }
  scope :sitewide, -> { where(sitewide: true) }

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

  def apply(price)
    amount = price.amount

    new_amount = \
      if fixed?
        discount_size < amount ? amount - discount_size : BigDecimal.new(0)
      elsif percentage?
        amount * (1 - discount_size.to_f / 100)
      else
        amount
      end

    Spree::Price.new(amount: new_amount, currency: price.currency)
  end

  def mega_menu_image_url
    "#{ENV['RAILS_ASSET_HOST']}/sale/#{name.downcase}.jpg"
  end

  def banner_images
    {
      full:  'tile-sale-full.gif',
      small: 'tile-sale-sml.gif'
    }
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

  def self.active_sales_ids
    Spree::Sale.active.pluck(:id)
  end

  def self.last_sitewide
    active.sitewide.order('created_at DESC').last
  end

end
