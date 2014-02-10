class CustomisationValue < ActiveRecord::Base
  acts_as_list :scope => :customisation_type

  belongs_to :customisation_type
  has_many :product_customisation_values, :dependent => :destroy

  attr_accessible :name, :presentation, :image, :price

  has_attached_file :image, styles: {
    mini: '48x48>',
    small: '78x94#'
  }

  def price
    read_attribute('price').to_f
  end

  def display_price
    Spree::Money.new(price)
  end
end
