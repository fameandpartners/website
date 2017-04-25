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
  before_save :rename_files

  def rename_files
    if( base_image_file_name.present? )
      extension = File.extname(base_image_file_name).gsub(/^\.+/, '')      
      base_image.instance_write(:file_name, "base-#{customizations_on.join( "-" )}.#{extension}" )
    end

    if( layer_image_file_name.present? )
      extension = File.extname(layer_image_file_name).gsub(/^\.+/, '')            
      layer_image.instance_write(:file_name, "layer-#{customizations_on.join( "-" )}.#{extension}" )
    end

    true
  end

  private
  def customizations_on
    to_return = []
    (1..4).each do |i|
      if( self.send( "customization_#{i}" ) )
        to_return << i
      end
    end
    to_return
  end
  
  
end
