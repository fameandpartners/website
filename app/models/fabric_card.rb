class FabricCard < ActiveRecord::Base
  INVALID_SKU_CODE = '----'

  attr_accessible :name, :code

  validates_presence_of :name

  has_many :colours, class_name: 'FabricCardColour'
  has_many :fabric_colours, through: :colours
  has_many :spree_products, inverse_of: :fabric_card, class_name: 'Spree::Product'

  def self.hydrated
    includes(:colours => :fabric_colour)
  end

  def sku_component
    code.presence || INVALID_SKU_CODE
  end
end
