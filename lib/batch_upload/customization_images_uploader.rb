require 'batch_upload/images_uploader'

module BatchUpload
  class CustomizationImagesUploader < ImagesUploader
    def process!
      each_product do |product, path|
        get_list_of_directories(path).each do |directory_path|
          directory_name = File.basename directory_path

          next unless directory_name =~ /customisations?|customizations?/i

          get_list_of_files(directory_path).each do |file_path|
            begin
              file_name = File.basename file_path

              matches = /^(?<position>\d+)\S+/.match(file_name)

              if matches.blank?
                error "File name #{file_name} requires a position!"
                next
              else
                position = matches[:position]
              end

              customization = product.customisation_values.where(position: position).first

              if customization.blank?
                error "Customisation image found for SKU: #{product.sku} position:(#{position}) but missing customization item. (#{file_name})"
                next
              end

              next if test_run?

              customization.image = File.open(file_path)

              if customization.save
                success "Customisation", name: customization.name, pos: position, file: file_name
              else
                error "Customization can not updated: #{customization.errors.full_messages.map(&:downcase).to_sentence}"
              end
            rescue Exception => message
              error "#{message.inspect}"
            end
          end
        end
      end
    end
  end
end
