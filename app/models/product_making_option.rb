# todo: thanh 3/31/17
# Would prefer to replace this mechanism for discounts with a more
# spree conventional solution in the future
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
  scope :slow_making, -> { where(option_type: 'slow_making') }
  scope :active, -> { where(active: true) }

  def assign_default_attributes
    self.active     = true
    self.variant_id ||= product.try(:master).try(:id) #seems like this is deprecated
    self.price      ||= DEFAULT_OPTION_PRICE
    self.currency   ||= DEFAULT_CURRENCY
    self
  end

  def display_price
    Spree::Money.new(price, currency: currency, no_cents: true)
  end

  def display_discount
    if self.fast_making?
      self.display_price.to_s
    elsif self.slow_making?
      (self.price*100*(-1)).round.to_s + '% OFF'
    else
      '' #bad
    end
  end

  def name
    if fast_making?
      'Express'
    else
      'Later'
    end
  end

  def description
    if fast_making?
      'Estimated Delivery in 2 weeks'
    else
      'Estimated Delivery in 8 weeks'
    end
  end

  # yes, this hardcoding is atrocious.
  def display_delivery_period
    if fast_making?
      '2 weeks'
    else
      'Estimated Delivery in 8 weeks'
    end
  end

  def fast_making?
    option_type == 'fast_making'
  end

  def slow_making?
    option_type == 'slow_making'
  end
end
