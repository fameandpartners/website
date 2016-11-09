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

              # NOTE: Alexey Bobyrev 08/11/16
              # For name examples - take a look on
              # "spec/lib/batch_upload/render3d_images_uploader_spec.rb"

              match_data, parse_error = self.class::FileParser.new(file_name: file_name).values

              if parse_error.present?
                errors.push(parse_error)
              end

              color_name = match_data[:color]
              customisation_name = match_data[:customisation]

              if color_name.present?
                debug "Search color by name"

                color_value = color_for_name(color_name)

                if color_value.blank?
                  errors.push({
                    kind: :error,
                    message: "Color not found (#{color_name}) '#{file_name}'"
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
                  if marker == 'c'
                    customisation_id_for_position(product, position)
                  elsif marker == 'd'
                    0
                  end

                if customisation_value_id.nil?
                  errors.push({
                    kind: :warn,
                    message: "Customisation not found (#{customisation_name}) '#{file_name}'"
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

              options = { product_id: product.id, color_value_id: color_value.id, customisation_value_id: customisation_value_id }
              image = find_or_initialize_render3d_image(options) do |img|
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

    class FileParser
      attr_reader :file_name, :data, :error

      def initialize(file_name: file_name)
        @file_name = file_name
        parse
      end

      def values
        [data, error]
      end

      private def parse
        cyrillic_index = check_for_cyrillic_symbols

        if cyrillic_index.present?
          @error = {
            kind: :error,
            message: "File cannot be parsed due to cyrrilic symbols on it - '#{file_name}':#{cyrillic_index}"
          }

          @data = {}
        else
          pattern = /(?<sku>\w+)[-,_](?<color>[\S\s]+)[-,_](?<customisation>\S+)\.\w+$/
          data = file_name.match(pattern)

          if data.nil?
            @error = {
              kind: :error,
              message: "File name is invalid and can't be parsed: '#{file_name}'"
            }

            @data = {}
          else
            @data = {
              sku: data[:sku].to_s.parameterize,
              color: data[:color].to_s.parameterize,
              customisation: data[:customisation].to_s.parameterize
            }
          end
        end
      end

      private def check_for_cyrillic_symbols
        file_name.index(/\p{Cyrillic}+/)
      end

    end

    def find_or_initialize_render3d_image(options, &block)
      image_class = Render3d::Image
      image = image_class.where(options).first || image_class.new

      if block_given?
        image.tap(&block)
      else
        image
      end
    end

    def color_for_name(color_name)
      Spree::OptionValue.colors.where('LOWER(name) = ?', color_name).first
    end

    def customisation_id_for_position(product, position)
      product.customisation_values.where(position: position).pluck('id').first
    end

  end
end
