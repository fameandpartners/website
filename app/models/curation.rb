class Curation < ActiveRecord::Base
    attr_accessible :product, :product_id, :pid, :images
  
    belongs_to :product, class_name: 'Spree::Product'
    has_many :images, as: :viewable, order: :position, class_name: "Spree::Image"
    has_and_belongs_to_many :taxons, class_name: "Spree::Taxon"
  
    validates :product,
              :presence => true
  
    validates :pid,
              :presence => true
  end
  