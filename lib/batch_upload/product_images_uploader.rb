require 'batch_upload/images_uploader'

module BatchUpload
  class ProductImagesUploader < ImagesUploader
    def process!
      each_product do |product, path|
        get_list_of_files(path).each do |file_path|
          begin
            file_name = File.basename file_path

            parts = file_name.split(/[\-\.]/)
            sku_idx = 0
            color_idx = 1
            position_idx = 2
            extension_idx = 3

            # 4B190-BURGUNDY-CROP.jpg
            # 4B190-BURGUNDY-FRONT-CROP.jpg
            # 4B190-NAVY-FRONT.jpg
            # 4B190-Black-4.jpg
            color_name = parts[color_idx].strip.downcase.underscore.dasherize.gsub(' ', '-')
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
              error "File name is invalid: #{file_name}"
              next
            end

            if color_name.present?
              debug "Search color by name"
              color = color_for_name(color_name)

              if color.blank?
                error "Color not found (#{color_name}) #{file_name}"
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

            next if test_run?

            if @_strategy.eql?(:delete)
              if viewable.is_a?(ProductColorValue)
                debug "Process existing images for color"
              elsif viewable.is_a?(Spree::Variant)
                debug "Process existing images for product"
              end

              info "Delete images which was created more then #{@_expiration / 3600} hours ago"

              viewable.images.where('attachment_updated_at < ?', @_expiration.ago).destroy_all
            end

            if ENV['USE_SPREE_IMAGE_CLASS']
              image = Spree::Image.create(
                  :attachment    => File.open(file_path),
                  :viewable_type => viewable.class.name,
                  :viewable_id   => viewable.id,
                  :position      => position
              )
            else
                geometry = geometry(file_path)
                image = FastImage.create(
                    :attachment        => File.open(file_path),
                    :attachment_width  => geometry.width,
                    :attachment_height => geometry.height,
                    :viewable_type     => viewable.class.name,
                    :viewable_id       => viewable.id,
                    :position          => position,
                    :type              => 'Spree::Image'
                )
            end

            if image.persisted?
              success "ProductImage", id: image.id, color: color_name, position: position, file: file_name
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
        # TODO - GB 2015.03.22 - Find out if this is needed here, or if we can push it off until the very end.
        # info "Updating Product Index SKU: #{product.sku}, NAME: #{product.name} ID: #{product.id}"
        # product.update_index
      end

      info "Please run rake import:product:reindex now!"
    end

    def geometry(file_path)
      Paperclip::Geometry.from_file(file_path)
    end

    def color_for_name(color_name)
      Spree::OptionValue.colors.where('LOWER(name) = ?', color_name).first
    end
  end
end
