class CustomisationValue < ActiveRecord::Base
  acts_as_list :scope => :customisation_type

  belongs_to :customisation_type
  has_many :product_customisation_values, :dependent => :destroy

  attr_accessible :name, :presentation, :image

  has_attached_file :image, styles: {
    mini: '48x48>', small: '100x100>', product: '240x240>', large: '600x600>'
  }
end
