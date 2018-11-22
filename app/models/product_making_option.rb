# todo: thanh 3/31/17
# Would prefer to replace this mechanism for discounts with a more
# spree conventional solution in the future
class ProductMakingOption < ActiveRecord::Base
  belongs_to :product, class_name: 'Spree::Product', touch: true
  belongs_to :making_option

  attr_accessible :making_option, :making_option_id, :active, :default, :product_id

  scope :active, -> { where(active: true) }

  def display_price(currency)
    making_option.display_price(currency)
  end

  def name
    making_option.name
  end

  def description
    making_option.description
  end

  def display_delivery_period
    making_option.delivery_period
  end

  def price_in(currency)
    making_option.price_in(currency)
  end
end
