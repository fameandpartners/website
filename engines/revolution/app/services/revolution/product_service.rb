module Revolution

  class ProductService
    attr_reader :ids, :colours, :site_version

    def initialize(product_ids, site_version)
      product_ids = product_ids.values if product_ids.respond_to?(:values)
      @ids = product_ids.collect{|pid| pid.split('-', 2)[0] }
      @colours = product_ids.collect{|pid| pid.split('-', 2)[1] }
      @site_version = site_version
    end

    def products
      spree_products.each_with_index.collect do |p, i|
        colour_name = colours[i]

        images = p.images.find_all{|i| i.attachment_file_name.downcase.include?(colour_name.gsub('-', '_')) && i.attachment_file_name.downcase.include?('crop') }
        images = images.sort_by{ |i| i.position }.collect{ |i| i.attachment.url(:large) }

        price = p.zone_price_for(site_version)
        color = Spree::OptionValue.where(:name => colour_name).first

        OpenStruct.new(
          :id => p.id,
          :name => p.name,
          :price => price,
          :discount => p.discount,
          :images => images,
          :color => color
        )
      end
    end

    def spree_products
      Spree::Product.where(:id => ids).all.sort_by{|p| ids.index(p.id.to_s) }
    end

  end
end
