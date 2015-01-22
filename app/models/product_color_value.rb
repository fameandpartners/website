class ProductColorValue < ActiveRecord::Base
  attr_accessible :option_value

  belongs_to :product, class_name: 'Spree::Product'
  belongs_to :option_value, class_name: 'Spree::OptionValue'

  has_many :images, as: :viewable, order: :position, dependent: :destroy, class_name: "Spree::Image"
end