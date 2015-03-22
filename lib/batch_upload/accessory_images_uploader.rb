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
              file_name = File.basename file_path

              begin
                position, style_name = split_filename(file_name)
              rescue InvalidArgumentException => e
                error e.message
                next
              end

              style = Style.find_by_name(style_name)

              if style.blank?
                error "Accessory image found for SKU: #{product.sku} style=#{style_name} but no style found. (#{file_name})"
                next
              end

              accessory = product.accessories.where(style_id: style.id, position: position).first

              if accessory.blank?
                error "Accessory image found for SKU: #{product.sku} style=#{style_name} position=#{position} but no accessory found. (#{file_name})"
                next
              end

              accessory.image = File.open(file_path)

              if accessory.save
                success "Accessory", id: accessory.id, title: accessory.title, style: style_name, pos: position, file: file_name
              else
                error "Accessory (#{accessory.title} id=#{accessory.id}) can not updated: #{accessory.errors.full_messages.map(&:downcase).to_sentence}"
              end
            rescue Exception => message
              error "#{message.inspect}"
            end
          end
        end
      end
    end

    def split_filename(file_name)
      matches = /^(?<style_name>\S+)\s*(?<position>\d+)\s*\.\S+/.match(file_name)

      if matches.blank? || matches[:style_name].blank? || matches[:position].blank?
        raise ArgumentError.new("File name requires style and position: #{file_name}")
      end

      position = matches[:position].to_s.to_i
      style_name = matches[:style_name].downcase
      style_name.gsub!('boho', 'bohemian')
      [position, style_name]
    end
  end
end
