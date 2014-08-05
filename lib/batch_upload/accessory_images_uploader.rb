require 'batch_upload/images_uploader'

module BatchUpload
  class AccessoryImagesUploader < ImagesUploader
    def process!
      each_product do |product, path|
        get_list_of_directories(path).each do |directory_path|
          directory_name = directory_path.rpartition('/').last.strip

          next unless directory_name =~ /styleit/i

          get_list_of_files(directory_path).each do |file_path|
            begin
              puts ""
              puts ""
              file_name = file_path.rpartition('/').last.strip

              puts "  [INFO] Process \"#{file_name}\" file"
              puts "  [INFO] Parse file name"

              matches = /^(?<style_name>\S+)(?<position>\d+)\.\S+/.match(file_name)

              if matches.blank? || matches[:style_name].blank? || matches[:position].blank?
                puts "  [ERROR] File name is invalid"
                next
              else
                puts "  [INFO] File name successfully parsed"
                puts "    POSITION:   #{matches[:position]}"
                puts "    STYLE NAME: #{matches[:style_name]}"
              end

              puts "  [INFO] Process parsed data"

              position = matches[:position].to_s.to_i

              puts "    POSITION:   #{position}"

              style_name = matches[:style_name].downcase == 'boho' ? 'bohemian' : matches[:style_name].downcase

              puts "    STYLE NAME: #{style_name}"

              puts "  [INFO] Search style by name"

              style = Style.find_by_name(style_name)

              if style.blank?
                puts "  [ERROR] Style not found"
                next
              else
                puts "  [INFO] Style successfully found"
                puts "    ID:    #{style.id}"
                puts "    TITLE: #{style.title}"
              end

              puts "  [INFO] Search accessory by style and position"

              accessory = product.accessories.where(style_id: style.id, position: position).first

              if accessory.blank?
                puts "  [ERROR] Accessory not found"
                next
              else
                puts "  [INFO] Accessory successfully found"
                puts "    ID:   #{accessory.id}"
                puts "    NAME: #{accessory.title}"
              end

              accessory.image = File.open(file_path)

              if accessory.save
                puts "  [INFO] Accessory successfully updated"
              else
                puts "  [ERROR] Accessory can not updated"
                puts "    MESSAGES: #{accessory.errors.full_messages.map(&:downcase).to_sentence}"
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
