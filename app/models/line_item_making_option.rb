class LineItemMakingOption < ActiveRecord::Base
  belongs_to :product,    class_name: 'Spree::Product'
  belongs_to :line_item,  class_name: 'Spree::LineItem'
  belongs_to :product_making_option, class_name: 'ProductMakingOption', foreign_key: :making_option_id

  delegate :name, to: :product_making_option, allow_nil: true
  delegate :description, to: :product_making_option
  delegate :display_delivery_period, to: :product_making_option

  def display_price
    MakingOption.display_price(flat_price, percent_price, currency)
  end

  class << self
    def build_option(product_making_option, currency)
      new({
        product_id: product_making_option.product_id,
        making_option_id: product_making_option.id,
        flat_price: product_making_option.making_option.flat_price_in(currency),
        percent_price: product_making_option.making_option.percent_price_in(currency),
        currency: currency
      }, { without_protection: true })
    end
  end
end
