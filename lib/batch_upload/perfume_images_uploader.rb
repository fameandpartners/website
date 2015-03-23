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
              file_name = File.basename file_path

              perfume = product.moodboard_items.parfume.first

              if perfume.blank?
                error "Perfume image found for SKU: #{product.sku} but missing perfume item. (#{file_name})"
                next
              end

              perfume.image = File.open(file_path)

              if perfume.save
                success "Perfume", file: file_name
              else
                error "Perfume can not updated: #{perfume.errors.full_messages.map(&:downcase).to_sentence}"
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
