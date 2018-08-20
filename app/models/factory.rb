class Factory < ActiveRecord::Base
  attr_accessible :name, :production_email

  validates_presence_of :name

  has_many :products, :class_name => "Spree::Product"

  def to_s
    name
  end

  def self.for_product(product)
    product.factory || new(name: 'Unknown')
  end
end
