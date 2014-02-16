namespace :images do
  desc 'Upload images from directory supplied by LOCATION and associate with products & colors by file name'
  task :import => :environment do
    product_sku_regexp = /(?<sku>[[:alnum:]]+)[\-_]?/i
    product_image_regexp = /(^\S+[\-_]+(?<color>\S+)[\-_]+(?<position>\S+)\.(?<extension>\S+))|(\S+[\-_]+(?<position>\S+)\.(?<extension>\S+))$/i

    require 'pathname'

    raise 'Directory to import images is not set' unless ENV['LOCATION'].present?
    raise 'Directory do not exist' unless Dir.exists?(ENV['LOCATION'])

    location = Pathname(ENV['LOCATION']).realpath

    Dir["#{location}/*"].each do |product_directory_path|
      next unless File.directory?(product_directory_path)

      product_directory_name = product_directory_path.rpartition('/').last.strip

      matches = product_sku_regexp.match(product_directory_name)

      unless matches.present? # directory have invalid format of name
        puts "Directory \"#{product_directory_name}\" have invalid format of name"
        next
      end

      master = Spree::Variant.where(['LOWER(sku) = ? AND is_master = ?', matches[:sku].downcase, true]).first

      product = master.try(:product)

      unless product.present? # product with given sku can not be find
        puts "Product with given sku \"#{matches[:sku]}\" can not be find"
        next
      end

      Dir["#{product_directory_path}/*"].each do |content_path|
        content_name = content_path.rpartition('/').last.strip

        if File.file?(content_path)
          matches = product_image_regexp.match(content_name)

          unless matches.present? # directory have invalid format of name
            puts "File \"#{content_name}\" have invalid format of name"
            next
          end

          position = matches[:position].downcase.include?('front') ? 0 : matches[:position].to_s.to_i

          if matches[:color].present?
            color = matches[:color].strip.downcase
            option_value = product.option_types.find_by_name('dress-color').option_values.detect do |option_value|
              option_value.name.downcase.eql?(color) || option_value.presentation.downcase.eql?(color)
            end
          #else
          #  option_value = product.option_types.find_by_name('dress-color').option_values.first
          end

          if matches[:color].present? && option_value.blank? # color with given name can not be find
            puts "Color with the given name \"#{matches[:color]}\" can not be find"
            next
          end

          if option_value.present?
            viewable = ProductColorValue.where(product_id: product.id, option_value_id: option_value.id).first_or_create
          else
            viewable = master
          end

          if viewable.is_a?(ProductColorValue)
            viewable.images.where('attachment_updated_at < ?', 1.week.ago).destroy_all
          end

          Spree::Image.create!(
            :attachment    => File.open(content_path),
            :viewable_type => viewable.class.name,
            :viewable_id   => viewable.id,
            :position      => position
          )

          if viewable.is_a?(ProductColorValue)
            puts "File \"#{content_name}\" was loaded and attached to product \"#{product.name}\" and color \"#{viewable.option_value.presentation}\""
          else
            puts "File \"#{content_name}\" was loaded and attached to product \"#{product.name}\""
          end
        elsif File.directory?(content_path)
          file_paths = Dir["#{content_path}/*"]
          file_paths.select!{ |file_path| File.file?(file_path) }
          file_data = Hash[file_paths.map{|file_path| [file_path, file_path.rpartition('/').last.strip] }]

          case content_name
            when /customisations?/i then
              file_data.each do |file_path, file_name|
                matches = /^(?<position>\d+)\.\S+/.match(file_name)
                position = matches.present? ? matches[:position] : nil
                unless position.present?
                  puts "File \"#{file_name}\" should have digital name, which contain position of customization for \"#{product.name}\""
                  next
                end

                customization = product.customisation_values.where(position: position).first

                unless customization.present?
                  puts "Customization for \"#{product.name}\" with position \"#{position}\" was not found"
                  next
                end

                customization.image = File.open(file_path)

                if customization.save
                  puts "File \"#{file_name}\" was loaded for Customization with name \"#{customization.name}\" to product \"#{product.name}\""
                end
              end
            when /moodboard/i then
              file_data.each do |file_path, file_name|
                matches = /^(?<position>\d+)\.\S+/.match(file_name)
                position = matches.present? ? matches[:position] : nil
                moodboard = product.moodboard_items.moodboard.build do |object|
                  object.image = File.open(file_path)
                  object.position = position
                end
                if moodboard.save
                  puts "File \"#{file_name}\" was loaded as Moodboard to product \"#{product.name}\""
                end
              end
            when /perfume/i then
              puts 'Perfume'
            when /song/i then
              file_data.each do |file_path, file_name|
                song = product.moodboard_items.song.first

                unless song.present?
                  puts "Song was not found for product \"#{product.name}\""
                  next
                end

                song.image = File.open(file_path)
                if song.save
                  puts "File \"#{file_name}\" was loaded as Song (Moodboard) to product \"#{product.name}\""
                end
              end
            when /styleit/i then
              file_data.each do |file_path, file_name|
                matches = /^(?<style>\S+)(?<position>\d+)\.\S+/.match(file_name)

                if matches[:style].blank? || matches[:position].blank?
                  puts "File \"#{file_name}\" have invalid format of name"
                  next
                end

                if matches[:style].downcase == 'boho'
                  style = Style.find_by_name('bohemian')
                else
                  style = Style.find_by_name(matches[:style].downcase)
                end

                if style.blank?
                  puts "Style with name \"#{matches[:style].downcase}\" was not found"
                  next
                end

                accessory = product.accessories.where(style_id: style.id, position: matches[:position]).first

                if accessory.blank?
                  puts "Accessory for style \"#{style.name}\" with position \"#{matches[:position]}\" was not found"
                  next
                end

                accessory.image = File.open(file_path)
                if accessory.save
                  puts "File \"#{file_name}\" was loaded for Accessory in product \"#{product.name}\""
                end
              end
            else
              puts "Directory #{content_name} has invalid format of name"
          end
        end
      end
    end
  end
end
