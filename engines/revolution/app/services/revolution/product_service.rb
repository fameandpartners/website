module Revolution

  class ProductService
    attr_reader :product_ids, :site_version

    def initialize(product_ids, site_version)
      @product_ids = product_ids.respond_to?(:values) ? product_ids.values : product_ids
      @site_version = site_version
    end

    def products(params, page_limit)
      start = (params[:offset].present? ? params[:offset].to_i : 0 )
      end_calc = (params[:offset].present? ? params[:offset].to_i + page_limit : page_limit)
      if ids.size >= end_calc
        id_end = page_limit - 1
      else
        id_end = (ids.size % page_limit) - 1
      end
      temp_ids = []
      (start..start+id_end).each do |i|
        temp_ids << ids[i]
      end

      if temp_ids[0].nil?
        OpenStruct.new()
      else
        temp_ids.each_with_index.collect do |id, i|
          p           = spree_products[id]
          colour_name = colours[i]

          images = p.images.find_all { |i| i.attachment_file_name.downcase.include?(colour_name.gsub('-', '_')) && i.attachment_file_name.downcase.include?('crop') }
          images = images.sort_by { |i| i.position }.collect { |i| i.attachment.url(:large) }

          price = p.site_price_for(site_version)
          color = Spree::OptionValue.where(:name => colour_name).first

          OpenStruct.new(
              :id       => p.id,
              :name     => p.name,
              :price    => price,
              :discount => p.discount,
              :images   => images,
              :color    => color
          )
        end
      end

    end

    def spree_products
      p = Spree::Product.where(:id => ids)
      Hash[*p.map{ |p| [p.id.to_s, p] }.flatten]
    end

    def ids
      @ids ||= product_ids.collect{|pid| pid.split('-', 2)[0] }
    end

    def colours
      @colours ||= product_ids.collect{|pid| pid.split('-', 2)[1] }
    end

  end
end
