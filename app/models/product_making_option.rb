class ProductMakingOption < ActiveRecord::Base
  belongs_to :product, class_name: 'Spree::Product'
  belongs_to :variant, class_name: 'Spree::Variant'

  OPTION_TYPES         = ['fast_making']
  DEFAULT_OPTION_TYPE  = 'fast_making'
  DEFAULT_OPTION_PRICE = BigDecimal.new(30)
  DEFAULT_CURRENCY     = 'USD'
  ALL_CURRENCIES       = ::Money::Currency.table.keys.map(&:to_s).map(&:upcase)

  # NOTE: `#option_type` is not related to Spree::OptionType at all!
  attr_accessible :option_type, :currency, :price, :active

  validates :option_type,
            inclusion:  OPTION_TYPES,
            presence:   true,
            uniqueness: { scope: :product_id }

  validates :price, numericality: { greater_than_or_equal_to: 0 }

  validates :currency, inclusion: ALL_CURRENCIES

  scope :fast_making, -> { where(option_type: 'fast_making') }
  scope :active, -> { where(active: true) }

  def assign_default_attributes
    self.active     = true
    self.variant_id ||= product.try(:master).try(:id)
    self.price      ||= DEFAULT_OPTION_PRICE
    self.currency   ||= DEFAULT_CURRENCY
    self
  end

  def display_price
    Spree::Money.new(price, currency: currency)
  end

  def name
    'Express Making'
  end

  def fast_making?
    option_type == 'fast_making'
  end
end
