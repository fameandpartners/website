class FabricCardColour < ActiveRecord::Base
  belongs_to :fabric_colour
  belongs_to :fabric_card
  attr_accessible :position

  validates_presence_of :position
end
