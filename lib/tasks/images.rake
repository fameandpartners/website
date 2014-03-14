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

      sku = matches[:sku].downcase.strip

      master = Spree::Variant.where(deleted_at: nil, is_master: true).where('LOWER(TRIM(sku)) = ?', sku).order('id DESC').first

      product = master.try(:product)

      unless product.present? # product with given sku can not be find
        puts "Product with given sku \"#{sku}\" can not be find"
        next
      else
        puts "Working on product ##{sku}"
      end

      Dir["#{product_directory_path}/*"].each do |content_path|
        content_name = content_path.rpartition('/').last.strip

        if File.file?(content_path) # && process_product_images?(sku)
          # begin
          #  matches = product_image_regexp.match(content_name)
          
          #  unless matches.present? # directory have invalid format of name
          #    puts "  File \"#{content_name}\" have invalid format of name"
          #    next
          #  end
          
          #  position = matches[:position].downcase.include?('front') ? 0 : matches[:position].to_s.to_i
          
          #  if matches[:color].present?
          #    color = matches[:color].strip.underscore.downcase.dasherize
          #    option_value = product.option_types.find_by_name('dress-color').option_values.where('LOWER(name) = ?', color).first
          #  end
          
          #  if matches[:color].present? && option_value.blank? # color with given name can not be find
          #    puts "  Color with the given name \"#{matches[:color]}\" can not be find"
          #    next
          #  end
          
          #  if option_value.present?
          #    puts "  Color: \"#{option_value.presentation}\", Position: \"#{matches[:position]}\""
          #  else
          #    puts "  Color: \"None\", Position: \"#{matches[:position]}\""
          #  end
          
          #  if option_value.present?
          #    viewable = ProductColorValue.where(product_id: product.id, option_value_id: option_value.id).first_or_create
          #  else
          #    viewable = master
          #  end
          
          #  if viewable.is_a?(ProductColorValue)
          #    viewable.images.where('attachment_updated_at < ?', 6.hours.ago).destroy_all
          #  end
          
          #  Spree::Image.create!(
          #    :attachment    => File.open(content_path),
          #    :viewable_type => viewable.class.name,
          #    :viewable_id   => viewable.id,
          #    :position      => position
          #  )
          
          #  if viewable.is_a?(ProductColorValue)
          #    puts "  File \"#{content_name}\" was loaded and attached to color \"#{viewable.option_value.presentation}\""
          #  else
          #    puts "  File \"#{content_name}\" was loaded and attached"
          #  end
          # rescue Exception => message
          #  puts "  #{message.inspect}"
          # end
        elsif File.directory?(content_path)
          begin
            file_paths = Dir["#{content_path}/*"]
            file_paths.select!{ |file_path| File.file?(file_path) }
            file_data = Hash[file_paths.map{|file_path| [file_path, file_path.rpartition('/').last.strip] }]

            case content_name
              when /customisations?|customizations?/i then
                file_data.each do |file_path, file_name|
                  matches = /^(?<position>\d+)\S+/.match(file_name)

                  position = matches.present? ? matches[:position] : nil

                  unless position.present?
                    puts "  File \"#{file_name}\" should have name started with digit, which contain position of customization for \"#{product.name}\""
                    next
                  end

                  customization = product.customisation_values.where(position: position).first

                  unless customization.present?
                    puts "  Customization for \"#{product.name}\" with position \"#{position}\" was not found"
                    next
                  end

                  customization.image = File.open(file_path)

                  if customization.save
                    puts "  File \"#{file_name}\" was loaded for Customization with name \"#{customization.name}\""
                  end
                end
              when /moodboard/i then
                #product.moodboard_items.moodboard.where('created_at < ?', 5.hour.ago).destroy_all
                #
                #file_data.each do |file_path, file_name|
                #  matches = /^(?<position>\d+)\.\S+/.match(file_name)
                #  position = matches.present? ? matches[:position] : nil
                #  moodboard = product.moodboard_items.moodboard.build do |object|
                #    object.image = File.open(file_path)
                #    object.position = position
                #  end
                #  if moodboard.save
                #    puts "  File \"#{file_name}\" was loaded as Moodboard"
                #  end
                #end
              when /perfume/i then
                #file_data.each do |file_path, file_name|
                #  parfume = product.moodboard_items.parfume.first
                #
                #  unless parfume.present?
                #    puts "  Parfume was not found for product \"#{product.name}\""
                #    next
                #  end
                #
                #  parfume.image = File.open(file_path)
                #  if parfume.save
                #    puts "  File \"#{file_name}\" was loaded as Parfume (Moodboard)"
                #  end
                #end
              when /song/i then
                #file_data.each do |file_path, file_name|
                #  song = product.moodboard_items.song.first
                #
                #  unless song.present?
                #    puts "  Song was not found for product \"#{product.name}\""
                #    next
                #  end
                #
                #  song.image = File.open(file_path)
                #  if song.save
                #    puts "  File \"#{file_name}\" was loaded as Song (Moodboard)"
                #  end
                #end
              when /styleit/i then
                #file_data.each do |file_path, file_name|
                #  matches = /^(?<style>\S+)(?<position>\d+)\.\S+/.match(file_name)
                #
                #  if matches.blank? || matches[:style].blank? || matches[:position].blank?
                #    puts "File \"#{file_name}\" have invalid format of name"
                #    next
                #  end
                #
                #  if matches[:style].downcase == 'boho'
                #    style = Style.find_by_name('bohemian')
                #  else
                #    style = Style.find_by_name(matches[:style].downcase)
                #  end
                #
                #  if style.blank?
                #    puts "Style with name \"#{matches[:style].downcase}\" was not found"
                #    next
                #  end
                #
                #  accessory = product.accessories.where(style_id: style.id, position: matches[:position]).first
                #
                #  if accessory.blank?
                #    puts "Accessory for style \"#{style.name}\" with position \"#{matches[:position]}\" was not found"
                #    next
                #  end
                #
                #  accessory.image = File.open(file_path)
                #  if accessory.save
                #    puts "File \"#{file_name}\" was loaded for Accessory in product \"#{product.name}\""
                #  end
                #end
              else
                puts "Directory #{content_name} has invalid format of name"
            end
          rescue Exception => message
            puts "  #{message.inspect}"
          end
        end
      end
    end

    Rake::Task['update:images:positions'].execute
  end
end

def process_product_images?(sku)
  ['4b001dl', '4b009dl', '4b012sl', '4b014sl', '4b018sl', '4b020dl',
   '4b026ss', '4b027ss', '4b028sl', '4b034dl', '4b035dl', '4b040sl',
   '4b041sl', '4b046', '4b048sl', '4b052', '1310003', '1310006ds',
   '1310012dl', '1310014', '1310016dl', '1310019cl', '1310020',
   '1310022dl', '1310023cl', '1310028dl', '1310029cl', 'fpss13003',
   'fpss13004', 'fpss13006', 'fpss13017', 'fpss13027', 'fpss13028',
   'fpss13037', 'fpss13055', 'fpss13056', 'fpss13059', 'fpss13063'].include?(sku)
end
