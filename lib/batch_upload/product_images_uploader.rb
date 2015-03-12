require 'batch_upload/images_uploader'

module BatchUpload
  class ProductImagesUploader < ImagesUploader
    def process!
      each_product do |product, path|
        get_list_of_files(path).each do |file_path|
          begin
            puts ""
            puts ""
            file_name = file_path.rpartition('/').last.strip

            puts "  [INFO] Process \"#{file_name}\" file"
            puts "  [INFO] Parse file name"

            parts = file_name.split(/[\-\.]/)
            puts parts
            sku_idx = 0
            color_idx = 1
            position_idx = 2
            extension_idx = 3

            # 4B190-BURGUNDY-CROP.jpg
            # 4B190-BURGUNDY-FRONT-CROP.jpg
            # 4B190-NAVY-FRONT.jpg
            # 4B190-Black-4.jpg
            color_name = parts[color_idx].strip.underscore.downcase.dasherize.gsub(' ', '-')
            position = parts[position_idx]
            extension = parts[extension_idx]

            if position.to_s.downcase == 'crop'
              position = "6"
            end

            if position.downcase == 'front'
              position = "0"
              if extension.downcase == 'crop'
                position = "5" # FRONT CROP
              end
            end

            if parts.empty?
              puts "  [ERROR] File name is invalid"
              next
            else
              puts "  [INFO] File name successfully parsed"
              puts "    POSITION: #{position}"
              puts "    COLOR:    #{color_name}"
              puts "  [INFO] Process parsed data"
              puts "    POSITION: #{position}"
            end

            if color_name.present?
              puts "  [INFO] Search color by name"
              color = Spree::OptionValue.colors.where('LOWER(name) = ?', color_name).first

              if color.blank?
                puts "  [ERROR] Color not found"
                next
              else
                puts "  [INFO] Color successfully found"
                puts "    ID:           #{color.id}"
                puts "    PRESENTATION: #{color.presentation}"
              end
            end

            if color_name.present? && color.present?
              viewable = ProductColorValue.
                where(product_id: product.id).
                where(option_value_id: color.id).first_or_create
            else
              viewable = product.master
            end

            if @_strategy.eql?(:delete)
              if viewable.is_a?(ProductColorValue)
                puts "  [INFO] Process existing images for color"
              elsif viewable.is_a?(Spree::Variant)
                puts "  [INFO] Process existing images for product"
              end

              puts "  [INFO] Delete images which was created more then #{@_expiration / 3600} hours ago"

              viewable.images.where('attachment_updated_at < ?', @_expiration.ago).destroy_all
            end

            puts "  [INFO] Create image"
            puts "    ATTACHMENT:    #{file_path}"
            puts "    VIEWABLE_TYPE: #{viewable.class.name}"
            puts "    VIEWABLE_ID:   #{viewable.id}"
            puts "    POSITION:      #{position}"

            image = Spree::Image.create(
              :attachment    => File.open(file_path),
              :viewable_type => viewable.class.name,
              :viewable_id   => viewable.id,
              :position      => position
            )

            if image.persisted?
              puts "  [INFO] Image successfully created"
            else
              puts "  [ERROR] Image can not created"
              puts "    MESSAGES: #{image.errors.full_messages.map(&:downcase).to_sentence}"
            end

          rescue Exception => message
            puts "  [ERROR] #{message.inspect}"
          end
        end
      end
    end
  end
end
