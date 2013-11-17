namespace :images do
  desc 'Upload images from directory supplied by LOCATION and associate with products & colors by file name'
  task :import => :environment do
    regexp = /^((?<sku>\S+)[\-_]+(?<color>\S+)[\-_]+(?<position>\S+)\.(?<extension>\S+))|((?<sku>\S+)[\-_]+(?<position>\S+)\.(?<extension>\S+))$/i

    require 'pathname'

    raise 'Directory to import images is not set' unless ENV['LOCATION'].present?
    raise 'Directory do not exist' unless Dir.exists?(ENV['LOCATION'])

    location = Pathname(ENV['LOCATION']).realpath

    Dir["#{location}/*.*"].each do |file_path|
      next unless File.file?(file_path)

      file_name = file_path.rpartition('/').last.strip

      matches = regexp.match(file_name)

      unless matches.present? # file have invalid format of name
        puts "File \"#{file_name}\" have invalid format of name"
        next
      end

      product = Spree::Variant.where(sku: matches[:sku], is_master: true).first.try(:product)

      unless product.present? # product with given sku can not be find
        puts "Product with given sku \"#{matches[:sku]}\" can not be find"
        next
      end

      position = matches[:position].downcase.include?('front') ? 0 : matches[:position].to_s.to_i

      if matches[:color].present?
        color = matches[:color].strip.downcase
        option_value = product.option_types.find_by_name('dress-color').option_values.detect do |option_value|
          option_value.name.downcase.eql?(color) || option_value.presentation.downcase.eql?(color)
        end
      else
        option_value = product.option_types.find_by_name('dress-color').option_values.first
      end

      unless option_value.present? # color with given name can not be find
        puts "Color with the given name \"#{matches[:color]}\" can not be find"
        next
      end

      viewable = ProductColorValue.where(product_id: product.id, option_value_id: option_value.id).first_or_create

      Spree::Image.create!(
        :attachment    => File.open(file_path),
        :viewable_type => (viewable || product).class.name,
        :viewable_id   => (viewable || product).id,
        :position      => position
      )

      if viewable.present?
        puts "File \"#{file_name}\" was loaded and attached to product \"#{product.name}\" and color \"#{viewable.option_value.presentation}\""
      else
        puts "File \"#{file_name}\" was loaded and attached to product \"#{product.name}\""
      end
    end
  end
end
