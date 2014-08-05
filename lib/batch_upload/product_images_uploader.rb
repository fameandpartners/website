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

            matches = /(^\S+[\-_]+(?<color_name>[^-]+)[\-_]+(?<position>\S+)\.(?<extension>\S+))|(\S+[\-_]+(?<position>\S+)\.(?<extension>\S+))$/i.match(file_name)

            if matches.blank?
              puts "  [ERROR] File name is invalid"
              next
            else
              puts "  [INFO] File name successfully parsed"
              puts "    POSITION: #{matches[:position]}"
              puts "    COLOR:    #{matches[:color_name]}"
            end

            puts "  [INFO] Process parsed data"

            position = matches[:position].downcase.include?('front') ? 0 : matches[:position].to_s.to_i

            puts "    POSITION: #{position}"

            if matches[:color_name].present?
              color_name = matches[:color_name].strip.underscore.downcase.dasherize.gsub(' ', '-')
              puts "    COLOR:   #{color_name}"
            else
              color_name = nil
              puts "    COLOR:   NONE"
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
