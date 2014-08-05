require 'batch_upload/images_uploader'

module BatchUpload
  class SongImagesUploader < ImagesUploader
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

              puts "  [INFO] Search song"

              song = product.moodboard_items.song.first

              if song.blank?
                puts "  [ERROR] Song not found"
                next
              else
                puts "  [INFO] Song successfully found"
              end

              song.image = File.open(file_path)

              if song.save
                puts "  [INFO] Song successfully updated"
              else
                puts "  [ERROR] Song can not updated"
                puts "    MESSAGES: #{song.errors.full_messages.map(&:downcase).to_sentence}"
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
