class LayerCad < ActiveRecord::Base
  attr_accessible :base_image_name, :position, :customization_1, :customization_2, :customization_3, :customization_4, :layer_image_name, :product_id

  belongs_to :product, class_name: 'Spree::Product'
  
  has_attached_file :base_image,
                    :styles => { :original => "944x800" },
                    :default_style => :original,
                    :url => '/spree/products/:product_id/cads/:id/:style/:basename.:extension',
                    :path => ':rails_root/public/spree/products/:product_id/cads/:id/:style/:basename.:extension',
                    :convert_options => { :all => '-strip -auto-orient' }

  has_attached_file :layer_image,
                    :styles => { :original => "944x800" },
                    :default_style => :original,
                    :url => '/spree/products/:product_id/cads/:id/:style/:basename.:extension',
                    :path => ':rails_root/public/spree/products/:product_id/cads/:id/:style/:basename.:extension',
                    :convert_options => { :all => '-strip -auto-orient' }
  
end
