require 'batch_upload/images_uploader'

module BatchUpload
  class SongImagesUploader < ImagesUploader
    def process!
      each_product do |product, path|
        get_list_of_directories(path).each do |directory_path|
          directory_name = directory_path.rpartition('/').last.strip

          next unless directory_name =~ /song/i

          get_list_of_files(directory_path).each do |file_path|
            begin
              file_name = File.basename file_path

              song = product.moodboard_items.song.first

              if song.blank?
                error "Song image found for SKU: #{product.sku} but missing moodboard item. (#{file_name})"
                next
              end

              song.image = File.open(file_path)

              if song.save
                success "Song", song_id: song.id, file_name: file_name
              else
                error "Song for #{product.sku} not saved: #{song.errors.full_messages.map(&:downcase).to_sentence}"
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
