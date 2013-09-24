class ProductCustomisationType < ActiveRecord::Base
  belongs_to :product, class_name: 'Spree::Product'
  belongs_to :customisation_type

  has_many :product_customisation_values
  has_many :customisation_values, through: :product_customisation_values

  attr_accessible :customisation_type_id, :product_customisation_values_attributes
  accepts_nested_attributes_for :product_customisation_values, reject_if: lambda { |cv| cv[:customisation_value_id].blank? }
end