require 'batch_upload/images_uploader'

module BatchUpload
  class Render3dImagesUploader < ImagesUploader

    def process!
      each_product do |product, path|
        get_list_of_directories(path).each do |directory_path|
          directory_name = File.basename directory_path

          next unless directory_name =~ /render3d?/i

          get_list_of_files(directory_path).each do |file_path|
            begin
              errors = []
              file_name = File.basename(file_path)

              # 4B141-PLUM-C1.jpg
              # 4B141_PLUM-C3.jpg
              # 4B141-RED-D.jpg
              # 4B141-SAGE-GREEN-C2.jpg

              match_data = \
                file_name.match(/(?<sku>\w+)[-,_](?<color>\S+)[-,_](?<customisation>\w+).\w+$/)

              if match_data.nil?
                errors.push({
                  kind: :error,
                  message: "File name is invalid: #{file_name}"
                })
                match_data = {}
              end

              color_name = match_data[:color].to_s.downcase
              customisation_name = match_data[:customisation].to_s.downcase

              if color_name.present?
                debug "Search color by name"

                color_value = color_for_name(color_name)

                if color_value.blank?
                  errors.push({
                    kind: :error,
                    message: "Color not found (#{color_name}) #{file_name}"
                  })
                end
              end

              if customisation_name.present?
                debug "Search customisation by position"

                marker, position = \
                  customisation_name.match(/^(?<marker>\w)(?<position>\d)?$/).captures

                # C - image for customisation
                # D - (default) image for color
                customisation_value_id = \
                  if marker == 'C'
                    customisation_id_for_position(product, position)
                  elsif marker == 'D'
                    0
                  end

                if customisation_value_id.nil?
                  errors.push({
                    kind: :warn,
                    message: "Customisation not found (#{customisation_name}) #{file_name}"
                  })
                end
              end

              if test_run?
                errors.push({})
              end

              if errors.present?
                errors.each do |e|
                  send(e[:kind], e[:message]) if e[:kind].present?
                end

                next
              end

              image = Render3d::Image.new.tap do |img|
                img.product = product
                img.color_value = color_value
                img.customisation_value_id = customisation_value_id

                img.attachment = File.open(file_path)

                img.save!
              end

              if image.persisted?
                success "Render3d::Image", id: image.id, color: color_name, position: position, product_id: product.id, file: file_name
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
    end

    def color_for_name(color_name)
      Spree::OptionValue.colors.where('LOWER(name) = ?', color_name).first
    end

    def customisation_id_for_position(product, position)
      product.customisation_values.where(position: position).select('id').first
    end

  end
end
