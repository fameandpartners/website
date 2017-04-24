class LayerCad < ActiveRecord::Base
  attr_accessible :base_image_name, :position, :customizations_enabled_for, :layer_image_name, :product_id, :width, :height
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
  before_save :rename_files

  def rename_files
    if( self.respond_to?(:base_image_file_name) && base_image_file_name.present? )
      extension = File.extname(base_image_file_name).gsub(/^\.+/, '')
      base_image.instance_write(:file_name, "base-#{customizations_on.join( "" )}.#{extension}" )
    end

    if( self.respond_to?(:layer_image_file_name) && layer_image_file_name.present? )
      extension = File.extname(layer_image_file_name).gsub(/^\.+/, '')
      layer_image.instance_write(:file_name, "layer-#{customizations_on.join( "" )}.#{extension}" )
    end

    true
  end

  private
  def customizations_on
    to_return = []
    customizations_enabled_for.each_with_index do |customization, i|
      if( customization )
        to_return << i
      end
    end
    to_return
  end


end
