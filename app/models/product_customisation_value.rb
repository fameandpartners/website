class ProductCustomisationValue < ActiveRecord::Base
  belongs_to :customisation_value
  belongs_to :product, class_name: 'Spree::Product', foreign_key: :product_id
  #belongs_to :product_customisation_type

  #has_and_belongs_to_many  :customisation_values, join_table: 'product_customisation_values'

  has_attached_file :image, styles: {
    mini: '48x48>', small: '100x100>', product: '240x240>'#, large: '600x600>'
  }

  attr_accessible :customisation_value_id, :image, :price

  before_create :populate_from_customisation_value

  def populate_from_customisation_value
    self.name ||= self.customisation_value.name
    self.presentation ||= self.customisation_value.presentation
    self.price ||= self.customisation_value.price
  end

  def price
    (read_attribute(:price) || self.customisation_value.price).to_f
  end

  def display_price
    Spree::Money.new(price)
  end
end
