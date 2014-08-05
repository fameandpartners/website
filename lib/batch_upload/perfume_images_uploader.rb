require 'batch_upload/images_uploader'

module BatchUpload
  class PerfumeImagesUploader < ImagesUploader
    def process!
      each_product do |product, path|
        get_list_of_directories(path).each do |directory_path|
          directory_name = directory_path.rpartition('/').last.strip

          next unless directory_name =~ /perfume/i

          get_list_of_files(directory_path).each do |file_path|
            begin
              puts ""
              puts ""
              file_name = file_path.rpartition('/').last.strip

              puts "  [INFO] Process \"#{file_name}\" file"

              puts "  [INFO] Search perfume"

              perfume = product.moodboard_items.parfume.first

              if perfume.blank?
                puts "  [ERROR] Perfume not found"
                next
              else
                puts "  [INFO] Perfume successfully found"
              end

              perfume.image = File.open(file_path)

              if perfume.save
                puts "  [INFO] Perfume successfully updated"
              else
                puts "  [ERROR] Perfume can not updated"
                puts "    MESSAGES: #{perfume.errors.full_messages.map(&:downcase).to_sentence}"
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
