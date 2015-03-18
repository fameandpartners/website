require 'batch_upload/images_uploader'

module BatchUpload
  class ProductImagesUploader < ImagesUploader
    def process!
      each_product do |product, path|
        get_list_of_files(path).each do |file_path|
          begin
            file_name = file_path.rpartition('/').last.strip

            info "File: \"#{file_name}\""

            parts = file_name.split(/[\-\.]/)
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
              error "File name is invalid"
              next
            end

            if color_name.present?
              debug "Search color by name"
              color = color_for_name(color_name)

              if color.blank?
                error "Color not found"
                next
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
                debug "Process existing images for color"
              elsif viewable.is_a?(Spree::Variant)
                debug "Process existing images for product"
              end

              info "Delete images which was created more then #{@_expiration / 3600} hours ago"

              viewable.images.where('attachment_updated_at < ?', @_expiration.ago).destroy_all
            end

            info "Create image"
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
              info "Image: id: #{image.id}"
            else
              error "Image can not created #{image.errors.full_messages.map(&:downcase).to_sentence}"
            end

          rescue Interrupt
            error "Operation aborted by user..."
            abort("SIGINT")
          rescue StandardError => message
            error "#{message.inspect}"
          end
        end
      end
    end

    def color_for_name(color_name)
      Spree::OptionValue.colors.where('LOWER(name) = ?', color_name).first
    end
  end
end
