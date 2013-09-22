class CustomisationType < ActiveRecord::Base
  acts_as_list

  has_many :customisation_values, :order => :position, :dependent => :destroy
  has_many :product_customisation_types, :dependent => :destroy

  attr_accessible :name, :presentation, :customisation_values_attributes

  validates :name, :presentation, :presence => true

  accepts_nested_attributes_for :customisation_values, :reject_if => lambda { |cv| cv[:name].blank? || cv[:presentation].blank? }, :allow_destroy => true
end
