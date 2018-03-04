require 'batch_upload/images_uploader'

module BatchUpload
  class ProductImagesUploader < ImagesUploader
    def process!( color_data )
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
            sku = parts[sku_idx].strip
            if( sku.downcase != product.sku.downcase )
              error "Skipping file #{file_name}"
            else
              fabric_color_code = parts[color_idx].strip

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
              fabrics_product = nil
              if fabric_color_code.present?
                debug "Looking up fabric color name"
                fabric_color_data = color_data[fabric_color_code.upcase]
                error "Unknown fabric color code #{fabric_color_code.upcase} for file name #{file_name}" if fabric_color_data.nil?
                fabrics_product = find_fabrics_product( sku, fabric_color_data )
                if fabrics_product.blank?
                  error "Fabric Product not found (#{fabric_color_code}) #{file_name}"
                  next
                end
              end
              
              if fabrics_product.present?
                viewable = fabrics_product
              else
                viewable = product.master
              end

              next if test_run?

              if @_strategy.eql?(:delete)
                if viewable.is_a?(FabricsProduct)
                  debug "Process existing images for color"
                elsif viewable.is_a?(Spree::Variant)
                  debug "Process existing images for product"
                end

                old_images = viewable.images.where('attachment_updated_at < ?', @_expiration.ago)
                if old_images.count > 0
                  warn "Delete SKU: #{product.sku} images which was created more than #{@_expiration / 3600} hours ago - total (#{old_images.count})"
                  old_images.delete_all
                end
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
                success "ProductImage", id: image.id, color: fabric_color_code, position: position, file: file_name
              else
                error "Image can not created #{image.errors.full_messages.map(&:downcase).to_sentence}"
              end
            end
          rescue Interrupt
            error "Operation aborted by user..."
            abort("SIGINT")
          rescue StandardError => message
            error "#{message.inspect}"
            puts message.backtrace
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

    def find_fabrics_product( sku, fabric_color )
      color_option = Spree::OptionType.color.option_values.where('LOWER(presentation) = ?', fabric_color[:color_name].downcase).first
      puts "Unknown fabric color: #{fabric_color}" if color_option.nil?
      fabric = Fabric.find_by_material_and_option_value_id( fabric_color[:fabric_name], color_option.id )
      master = Spree::Variant.where(deleted_at: nil, is_master: true).where('LOWER(TRIM(sku)) = ?', sku).order('id DESC').first
      product = master.product
      FabricsProduct.find_by_fabric_id_and_product_id( fabric.id, product.id )
    end

  end
end
