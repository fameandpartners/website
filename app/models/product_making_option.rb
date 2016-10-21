class ProductMakingOption < ActiveRecord::Base
  belongs_to :product, class_name: 'Spree::Product'
  belongs_to :variant, class_name: 'Spree::Variant'

  OPTION_TYPES         = ['fast_making']
  DEFAULT_OPTION_TYPE  = 'fast_making'
  DEFAULT_OPTION_PRICE = BigDecimal.new(30)

  # NOTE: `#option_type` is not related to Spree::OptionType at all!
  attr_accessible :option_type, :currency, :price, :active

  validates :option_type, inclusion: OPTION_TYPES, presence: true
  validates :option_type, uniqueness: { scope: :product_id }

  scope :fast_making, -> { where(option_type: 'fast_making') }
  scope :active, -> { where(active: true) }

  def assign_default_attributes
    self.active     = true
    self.variant_id ||= product.try(:master).try(:id)
    self.price      ||= DEFAULT_OPTION_PRICE
    self.currency   ||= SiteVersion.default.currency
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
