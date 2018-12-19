# todo: thanh 3/31/17
# Would prefer to replace this mechanism for discounts with a more
# spree conventional solution in the future
class ProductMakingOption < ActiveRecord::Base
  belongs_to :product, class_name: 'Spree::Product', touch: true
  belongs_to :making_option

  attr_accessible :making_option, :making_option_id, :active, :default, :product_id

  scope :active, -> { where(active: true) }
end
