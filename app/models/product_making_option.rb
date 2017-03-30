class ProductMakingOption < ActiveRecord::Base
  belongs_to :product, class_name: 'Spree::Product', touch: true
  # Note: Spree::Variant relationship doesn't seems necessary for making options
  belongs_to :variant, class_name: 'Spree::Variant'

  DEFAULT_OPTION_TYPE  = 'fast_making'.freeze
  DEFAULT_OPTION_PRICE = 30
  DEFAULT_CURRENCY     = 'USD'.freeze
  ALL_CURRENCIES       = ::Money::Currency.table.keys.map(&:to_s).map(&:upcase).freeze
  OPTION_TYPES         = ['fast_making', 'slow_making']  #[DEFAULT_OPTION_TYPE].freeze

  # NOTE: `#option_type` is not related to Spree::OptionType at all!
  attr_accessible :option_type, :currency, :price, :active

  validates :option_type,
            inclusion:  OPTION_TYPES,
            presence:   true,
            uniqueness: { scope: :product_id }

  validates :price, numericality: true#{ greater_than_or_equal_to: 0 }

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
    if fast_making?
      'Express Making'
    else
      'Delayed Making'
    end
  end

  def fast_making?
    option_type == 'fast_making'
  end

  def slow_making?
    option_type == 'slow_making'
  end
end
