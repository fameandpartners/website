require 'batch_upload/images_uploader'

module BatchUpload
  class MoodboardImagesUploader < ImagesUploader
    def process!
      each_product do |product, path|
        get_list_of_directories(path).each do |directory_path|
          directory_name = directory_path.rpartition('/').last.strip

          next unless directory_name =~ /moodboards?/i

          get_list_of_files(directory_path).each do |file_path|
            begin
              puts ""
              puts ""
              file_name = file_path.rpartition('/').last.strip

              puts "  [INFO] Process \"#{file_name}\" file"
              puts "  [INFO] Parse file name"

              matches = /^(?<position>\d+)\.\S+/.match(file_name)

              puts "  [INFO] File name successfully parsed"

              if matches.present? && matches[:position].present?
                puts "    POSITION:   #{matches[:position]}"
              end

              puts "  [INFO] Process parsed data"

              position = matches.present? ? matches[:position] : nil

              puts "    POSITION:   #{position}"

              puts "  [INFO] Delete moodboards which was created more then #{@_expiration / 3600} hours ago"

              product.moodboard_items.moodboard.where('created_at < ?', @_expiration.ago).destroy_all

              puts "  [INFO] Create moodboard"
              puts "    ATTACHMENT:    #{file_path}"
              puts "    POSITION:      #{ position || 'NONE' }"

              moodboard = product.moodboard_items.moodboard.build do |object|
                object.image = File.open(file_path)
                object.position = position
              end

              if moodboard.save
                puts "  [INFO] Moodboard successfully created"
              else
                puts "  [ERROR] Moodboard can not created"
                puts "    MESSAGES: #{moodboard.errors.full_messages.map(&:downcase).to_sentence}"
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
