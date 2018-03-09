module Revolution
  class ProductService
    #TODO - bring ids and colours into same data structure.

    attr_reader :product_ids, :site_version

    def initialize(product_ids_ary, site_version)
      @product_ids  = product_ids_ary
      @site_version = site_version
    end

    def products(params, page_limit)
      revolution_ids = get_revolution_ids(params, page_limit).compact
      collect_products(revolution_ids, params)
    end

    def spree_products
      p = Spree::Product.where(:id => ids)
      Hash[*p.map { |p| [p.id.to_s, p] }.flatten]
    end

    def ids
      @ids ||= product_ids.collect { |pid| pid.split('-', 2)[0] }
    end

    def colours
      @colours ||= product_ids.collect { |pid| pid.split('-', 2)[1] }
    end

    def get_revolution_ids(params, page_limit)
      start    = (params[:offset].present? ? params[:offset].to_i : 0)

      revolution_ids = []
      (start..start+id_end(params, page_limit)).each do |i|
        revolution_ids << ids[i]
      end

      revolution_ids
    end

    def collect_products(revolution_ids, params)
      return [] if revolution_ids[0].nil?

      revolution_ids.each_with_index.collect do |id, i|
        p           = spree_products[id]

        if p.present? && !p.hidden
          colour_name = colours[params[:offset].to_i + i]

          images = collection_images(p, colour_name)

          price = p.site_price_for(site_version)
          color = Spree::OptionValue.where(:name => colour_name).first

          Products::Presenter.new(
            :id           => p.id,
            :sku          => p.sku,
            :variant_skus => p.variant_skus,
            :name         => p.name,
            :price        => price,
            :discount     => p.discount,
            :images       => images,
            :color        => color
          )
        end
      end.compact
    end

    def collection_images(product, colour_name)
      images = product.images.find_all { |i| i.attachment_file_name.downcase.include?(colour_name.gsub('-', '_')) && i.attachment_file_name.downcase.include?('crop') }

      images.sort_by { |i| i.position }.collect { |i| i.attachment.url(:large) }
    end

    def id_end(params, page_limit)
      end_calc = (params[:offset].present? ? params[:offset].to_i + page_limit : page_limit)
      if ids.size >= end_calc
        id_end = page_limit - 1
      else
        id_end = (ids.size % page_limit) - 1
      end

      id_end
    end

  end
end