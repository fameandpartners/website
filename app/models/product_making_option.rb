class ProductMakingOption < ActiveRecord::Base
  belongs_to :product, class_name: 'Spree::Product' 
  belongs_to :variant, class_name: 'Spree::Variant'

  OPTION_TYPES = ['fast_making']
  DEFAULT_OPTION_TYPE = 'fast_making'
  DEFAULT_OPTION_PRICE = BigDecimal.new(29)

  validates :option_type, inclusion: OPTION_TYPES, presence: true

  scope :fast_making, -> { where(option_type: 'fast_making') }

  before_validation do
    option_type ||= 'fast_making'
    variant_id  ||= (product.present? ? product.master.id : nil)
    price       ||= DEFAULT_OPTION_PRICE
    currency    ||= SiteVersion.default.currency
  end
end
