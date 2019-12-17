class LayerCad < ActiveRecord::Base
  attr_accessible :base_image, :layer_image, :base_image_name, :position, :customizations_enabled_for, :layer_image_name, :product_id, :width, :height
  serialize :customizations_enabled_for

  belongs_to :product, class_name: 'Spree::Product'

  has_attached_file :base_image,
                    :styles => lambda { |a|
                                           { :original => "944x800",
                                             :web => "#{a.instance.width}x#{a.instance.height}"
                                           }
                    },
                    :default_style => :web,
                    :url => '/spree/products/:product_id/cads/:id/:style/:basename.:extension',
                    :path => 'spree/products/:product_id/cads/:id/:style/:basename.:extension',
                    :processors => [:cropper]
  has_attached_file :layer_image,
                    :styles => lambda { |a|

                                           { :original => "944x800",
                                             :web => "#{a.instance.width}x#{a.instance.height}" }
                     },
                    :default_style => :web,
                    :url => '/spree/products/:product_id/cads/:id/:style/:basename.:extension',
                    :path => 'spree/products/:product_id/cads/:id/:style/:basename.:extension',
                    :processors => [:cropper]


end
