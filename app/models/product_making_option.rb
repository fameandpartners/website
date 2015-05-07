class ProductMakingOption < ActiveRecord::Base
  belongs_to :product, class_name: 'Spree::Product' 
  belongs_to :variant, class_name: 'Spree::Variant'

  OPTION_TYPES = ['fast_making']
  DEFAULT_OPTION_TYPE = 'fast_making'
  DEFAULT_OPTION_PRICE = BigDecimal.new(29)

  validates :option_type, inclusion: OPTION_TYPES, presence: true

  scope :fast_making, -> { where(option_type: 'fast_making') }
  scope :active, -> { where(active: true) }

  def assign_default_attributes
    self.variant_id  ||= (product.present? ? product.master.id : nil)
    self.price       ||= DEFAULT_OPTION_PRICE
    self.currency    ||= SiteVersion.default.currency
    self
  end

  def display_price
    Spree::Money.new(price, currency: currency)
  end
end
