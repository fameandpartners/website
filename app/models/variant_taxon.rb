# TODO REMOVE THIS
class VariantTaxon < ActiveRecord::Base
  attr_accessible :product, :taxon, :fabric_or_color

  belongs_to :product, class_name: 'Spree::Product'
  belongs_to :taxon, class_name: 'Spree::Taxon'


  validates :taxon,
            :presence => true

  validates :product,
            :presence => true

  validates :fabric_or_color,
            :presence => true
end
