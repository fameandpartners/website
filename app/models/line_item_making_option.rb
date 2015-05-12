class LineItemMakingOption < ActiveRecord::Base
  belongs_to :product,    class_name: 'Spree::Product' 
  belongs_to :variant,    class_name: 'Spree::Variant'
  belongs_to :line_item,  class_name: 'Spree::Variant'
  belongs_to :product_making_option, class_name: 'ProductMakingOption', foreign_key: :making_option_id

  def display_price
    Spree::Money.new(price, currency: currency)
  end

  class << self
    def build_option(making_option)
      new({
        product_id: making_option.product_id,
        variant_id: making_option.variant_id,
        making_option_id: making_option.id,
        price: making_option.price,
        currency: making_option.currency
      }, { without_protection: true })
    end
  end
end
