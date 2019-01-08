class FabricsProduct < ActiveRecord::Base
  attr_accessible :fabric, :product_id, :fabric_id, :recommended, :description, :price_aud, :price_usd, :active

  belongs_to :product, class_name: 'Spree::Product'

  belongs_to :fabric, class_name: 'Fabric'


  has_many :images, as: :viewable, order: :position, dependent: :destroy, class_name: "Spree::Image"
  
  validates :product_id, :fabric_id, presence: true

  def color_name
    fabric.option_value.name
  end

  def color_id
    fabric.option_value.id
  end

  def self.recommended
    where(recommended: true)
  end

  def self.custom
    where(recommended: false)
  end

  def self.active
    where(active: true)
  end

  def self.inactive
    where(active: false)
  end

  def price_in(currency)
    if currency.downcase == 'aud'
      return self.price_aud.to_f
    else
      return self.price_usd.to_f
    end
  end


  def discount
    product.discount
  end

  def discount_price_in(currency)
    Spree::Price.new(amount: price_in(currency)).apply(discount).price
  end
end
