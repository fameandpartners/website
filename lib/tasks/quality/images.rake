namespace :quality do
  desc 'check product images for broken images'
  task :images => :environment do

    products_with_errors = []
    Spree::Product.active.each do |prod|

      errors = []
      if prod.images.none? { |i| i.attachment_file_name.to_s.downcase.include?('crop') }
        errors << "missing-crop"
      end

      if prod.images.none? { |i| i.attachment_file_name.to_s.downcase.include?('front') }
        errors << "missing-front"
      end

      unless errors.empty?
        products_with_errors << prod.sku
        puts "#{prod.sku}, '#{prod.name}', #{errors.join(', ')}"
      end
    end
    puts "Total: #{products_with_errors.count}"
  end
end
