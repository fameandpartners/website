require 'batch_upload/images_uploader'

module BatchUpload
  class CadsImagesUploader < ImagesUploader
    def process!
      each_product do |product, path|
        get_list_of_directories(path).each do |directory_path|
          directory_name = File.basename directory_path
          next unless directory_name =~ /cads?/i
          product.layer_cads.each do |cad|
            info "************"
            info "#{path}/#{directory_name}"
            
            if( cad.base_image_name )
              cad.base_image = File.open( "#{path}/#{directory_name}/#{cad.base_image_name}" )
              cad.save
           end
            
            if( cad.layer_image_name )
              cad.layer_image = File.open( "#{path}/#{directory_name}/#{cad.layer_image_name}" )
              cad.save
            end
          end
        end
      end
    end
  end
end
