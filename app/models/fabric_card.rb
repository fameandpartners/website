class FabricCard < ActiveRecord::Base
  attr_accessible :name, :sku_component

  validates_presence_of :name

  has_many :fabric_card_colours
  has_many :fabric_colours, through: :fabric_card_colours
  has_many :spree_products, inverse_of: :fabric_card, class_name: 'Spree::Product'
end
