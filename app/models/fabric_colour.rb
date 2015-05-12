class FabricColour < ActiveRecord::Base
  attr_accessible :name
  has_many :fabric_card_colours
  has_many :fabric_cards, through: :fabric_card_colours

  validates_presence_of :name
end
