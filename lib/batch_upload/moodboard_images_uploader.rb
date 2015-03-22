require 'batch_upload/images_uploader'

module BatchUpload
  class MoodboardImagesUploader < ImagesUploader
    def process!
      each_product do |product, path|

        ## Garrow - 2015.03.22 -
        ## I think this code is causing issues for other types of
        ## moodboard items, like songs, So I am disabling it.
        ## TODO - Either remove or re-enable.
        # info "Delete product.moodboards where(age > #{@_expiration / 3600} hrs)"
        # product.moodboard_items.moodboard.where('created_at < ?', @_expiration.ago).destroy_all

        get_list_of_directories(path).each do |directory_path|
          directory_name = directory_path.rpartition('/').last.strip

          next unless directory_name =~ /moodboards?/i

          get_list_of_files(directory_path).each do |file_path|
            begin
              file_name = File.basename file_path

              matches = /^(?<position>\d+)\.\S+/.match(file_name)
              position = matches.present? ? matches[:position] : nil

              moodboard = product.moodboard_items.moodboard.build do |object|
                object.image = File.open(file_path)
                object.position = position
              end

              if moodboard.save
                success "Moodboard", position: position, file: file_name
              else
                error "Moodboard can not created #{moodboard.errors.full_messages.map(&:downcase).to_sentence}"
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
