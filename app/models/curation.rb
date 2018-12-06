class Curation < ActiveRecord::Base
    attr_accessible :product, :product_id, :pid, :images
  
    belongs_to :product, class_name: 'Spree::Product'
    has_many :images, as: :viewable, order: :position, class_name: "Spree::Image"
    has_and_belongs_to_many :taxons, class_name: "Spree::Taxon"

    default_scope include: [:images]
    scope :active, where(active: true)
  
    validates :product,
              :presence => true
  
    validates :pid,
              :presence => true


    def fabric_product
        product.fabric_products.find { |fp| pid.include?(fp.fabric.name) }
    end

    def product_color_value
        product.product_color_values.find { |pcv| pid.include?(pcv.option_value.name) }
    end
  end
  