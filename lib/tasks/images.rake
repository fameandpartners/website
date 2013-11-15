namespace :images do
  desc 'Upload images from directory supplied by LOCATION and associate with products & colors by file name'
  task :import => :environment do
    require 'pathname'

    raise 'Directory to import images is not set' unless ENV['LOCATION'].present?
    raise 'Directory do not exist' unless Dir.exists?(ENV['LOCATION'])

    location = Pathname(ENV['LOCATION']).realpath

    Dir["#{location}/*.*"].each do |file_path|
      next unless File.file?(file_path)

      file_name = file_path.rpartition('/').last.strip

      matches = /(?<sku>\S+)-(?<color>\S+)-(?<position>\S+)\.(?<extension>\S+)/i.match(file_name)

      next unless matches.present?

      product = Spree::Variant.where(sku: matches[:sku], is_master: true).first.try(:product)

      next unless product.present?

      color = matches[:color].strip.downcase
      position = matches[:position].downcase.include?('front') ? 0 : matches[:position].to_s.to_i

      option_value = product.option_types.find_by_name('dress-color').option_values.detect do |option_value|
        option_value.name.downcase.eql?(color) || option_value.presentation.downcase.eql?(color)
      end

      viewable = ProductColorValue.where(product_id: product.id, option_value_id: option_value.id).first_or_create

      Spree::Image.create!(
        :attachment    => File.open(file_path),
        :viewable_type => (viewable || product).class.name,
        :viewable_id   => (viewable || product).id,
        :position      => position
      )

      if viewable.present?
        puts "File #{file_name} was loaded and attached to product \"#{product.name}\" and color \"#{viewable.option_value.presentation}\""
      else
        puts "File #{file_name} was loaded and attached to product \"#{product.name}\""
      end
    end
  end
end
