class CustomisationValue < ActiveRecord::Base
  acts_as_list :scope => :customisation_type

  belongs_to :customisation_type
  has_many :product_customisation_values, :dependent => :destroy

  attr_accessible :name, :presentation, :image
end
