class ProductCustomisationValue < ActiveRecord::Base
  belongs_to :customisation_value
  belongs_to :product_customisation_type

  has_and_belongs_to_many  :customisation_values, join_table: 'product_customisation_values'

  has_attached_file :image, styles: {
    mini: '48x48>', small: '100x100>', product: '240x240>', large: '600x600>'
  }

  attr_accessible :customisation_value_id, :image
end