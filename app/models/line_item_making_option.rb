class LineItemMakingOption < ActiveRecord::Base
  belongs_to :product,    class_name: 'Spree::Product'
  belongs_to :variant,    class_name: 'Spree::Variant'
  belongs_to :line_item,  class_name: 'Spree::Variant'
  belongs_to :product_making_option, class_name: 'ProductMakingOption', foreign_key: :making_option_id

  delegate :name, to: :product_making_option, allow_nil: true
  delegate :display_discount, to: :product_making_option
  delegate :description, to: :product_making_option

  def display_price
    Spree::Money.new(price, currency: currency)
  end

  class << self
    def build_option(product_making_option)
      new({
        product_id: product_making_option.product_id,
        variant_id: product_making_option.variant_id,
        making_option_id: product_making_option.id,
        price: product_making_option.price,
        currency: product_making_option.currency
      }, { without_protection: true })
    end
  end
end
