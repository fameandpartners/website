require 'batch_upload/images_uploader'

module BatchUpload
  class CustomizationImagesUploader < ImagesUploader
    def process!
      each_product do |product, path|
        get_list_of_directories(path).each do |directory_path|
          directory_name = directory_path.rpartition('/').last.strip

          next unless directory_name =~ /customisations?|customizations?/i

          get_list_of_files(directory_path).each do |file_path|
            begin
              puts ""
              puts ""
              file_name = file_path.rpartition('/').last.strip

              puts "  [INFO] Process \"#{file_name}\" file"
              puts "  [INFO] Parse file name"

              matches = /^(?<position>\d+)\S+/.match(file_name)

              if matches.blank?
                puts "  [ERROR] File name is invalid"
                next
              else
                puts "  [INFO] File name successfully parsed"
                puts "    POSITION: #{matches[:position]}"
              end

              puts "  [INFO] Search customization by position"
              customization = product.customisation_values.where(position: matches[:position]).first

              if customization.blank?
                puts "  [ERROR] Customization not found"
                next
              else
                puts "  [INFO] Customization successfully found"
                puts "    ID:           #{customization.id}"
                puts "    PRESENTATION: #{customization.presentation}"
              end

              customization.image = File.open(file_path)

              if customization.save
                puts "  [INFO] Customization successfully updated"
              else
                puts "  [ERROR] Customization can not updated"
                puts "    MESSAGES: #{customization.errors.full_messages.map(&:downcase).to_sentence}"
              end
            rescue Exception => message
              puts "  [ERROR] #{message.inspect}"
            end
          end
        end
      end
    end
  end
end
