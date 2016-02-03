namespace :reports do
  desc 'SKUs for all time'
  task :skus => :environment do

    class SkuExtract < Struct.new(:sku, :style_number, :product_name, :variant_id, :size, :color_id, :color_name, :customisation_id, :customisation_name, :height_value, :total_sold, :total_cart)
    end


    skus = []

    Spree::Product.unscoped do
      Spree::Variant.find_each do |variant|
        # binding.pry
        begin
        skus << SkuExtract.new(
          variant.sku,
          variant.product.master.sku,
          variant.product.name,
          variant.id,
          variant.dress_size.try(:name),
          variant.dress_color.try(:id),
          variant.dress_color.try(:name),
          nil,
          nil,
          nil,
          0,
          0
        )
        rescue StandardError => e
          binding.pry
        end


        puts skus.last.inspect
      end
    end

    # class





  end
end
