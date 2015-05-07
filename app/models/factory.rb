class Factory < ActiveRecord::Base
  attr_accessible :name

  validates_presence_of :name

  has_many :products, :class_name => "Spree::Product"

  def to_s
    name
  end

  def self.for_product(product)
    product.factory || new(name: 'Unknown')
    # new(name: product.property(:factory_name).presence || 'Unknown')
  end
end
