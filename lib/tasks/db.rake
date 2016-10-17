namespace :db do

  desc 'Reset PostgreSQL Sequences - Useful after database restores'
  task :reset_sequences => :environment do
    puts "Resetting PK Sequences"
    ActiveRecord::Base.connection.tables.each do |t|
      puts "Table: #{t}"
      ActiveRecord::Base.connection.reset_pk_sequence!(t)
    end
  end

  namespace 'render3d' do
    desc 'Add render3d images to product'
    task :add_to_product, [:folder_path] => [:environment] do |t, args|
      folder_path = args.fetch(:folder_path)
      product_id = folder_path.match(/product_(?<product_id>\d+)$/)[:product_id]

      product = Spree::Product.find(product_id)
      color_values = product.product_color_values
      customisation_values = product.customisation_values

      mapped_customisation_lists = [{
        product_id: '539',
        list: {
          'c1' => 'remove-splits',
          'c3' => 'make-into-a-mini-dress'
        }
      }]

      mapped_customisation_list = mapped_customisation_lists.find { |val| val[:product_id] == product_id }[:list]

      Dir[File.join(folder_path, '*')].each do |img_file|
        color_name, customisation_name = img_file.match(/\w+[-,_](?<color_name>\w+)[-,_](?<customisation>\w+).\w+$/).captures

        color_name = color_name.downcase
        customisation_name = mapped_customisation_list[customisation_name.downcase]

        color_value = color_values.includes(:option_value).where('LOWER(spree_option_values.name) = ?', color_name).first
        customisation_value = customisation_values.where('LOWER(name) = ?', customisation_name).first

        if color_value.present? && customisation_value.present?
          puts " [*] Product #{product_id}: <color - #{color_name}> <customsization: #{customisation_name}>"

          Render3d::Image.new.tap do |img|
            img.product = product
            img.customisation_value = customisation_value
            img.product_color_value = color_value

            img.attachment = File.open(img_file)

            img.save!
          end
        end

      end # Dir

    end # task
  end # namespace

end
