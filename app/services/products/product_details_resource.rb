class Products::ProductDetailsResource
  attr_reader :accessor, :site_version, :product, :selected_color

  def initialize(options = {})
    @accessor         = options[:as]
    @site_version     = options[:site_version]
    @product          = product_with_associations(options[:product])
    @selected_color   = options[:selected_color]
  end

  def read
    # product details
    OpenStruct.new({
      sku:  product.sku,
      name: product.name,
      permalink: product.permalink,
      short_description: product_short_description,
      fabric: product_properties['fabric'],
      notes: product_properties['style_notes'],
      description: product_description,
      default_image: default_product_image,
      images: product_images,
      price: product_price,
      sizes: default_product_sizes,
      extra_sizes: extra_product_sizes,
      colors: default_product_colors,
      extra_colors: extra_product_colors,
      extra_color_price: extra_product_color_price,
      extra_color_free: Spree::Config[:free_customisations],
      url: product_url,
      path: product_path,
      variants: product_variants,
      moodboard: product_moodboard
    })
  end

  private

    def product_variants
      @product_variants ||= Products::VariantsReceiver.new(product).available_options
    end

    def product_with_associations(product_candidate)
      Spree::Product.includes(:variants_including_master).find(product_candidate.id)
    end

    def default_product_image
      product_images.first.try(:large) || 'noimage/product.png'
    end

    # todo: add sort by preferred color & position
    def product_images
      Products::ProductImagesResource.new(
        product: product
      ).read_all.sort_by{|color| color.position.to_i }
    end

    def product_price
      @product_price ||= product.zone_price_for(site_version)
    end

    def product_properties
      @product_properties ||= begin
        {}.tap do |properties|
          product.product_properties.includes(:property).each do |product_property|
            properties[product_property.property.name] = product_property.value
          end
        end
      end
    end

    def product_short_description
      text = product_properties['short_description'] || product.description
      ActionView::Base.full_sanitizer.sanitize(text.to_s)
    rescue
      I18n.t('product_has_no_description')
    end

    def product_description
      product.description
    end

    def product_path
      '/us/dresses/dress-drama-queen-97'
    end

    def product_url
      'http://localhost:3600/us/dresses/dress-drama-queen-97'
    end

    # sizes
    def product_sizes
      @product_sizes ||= begin
        all_sizes = {}
        product_variants.each do |variant_info|
          all_sizes[variant_info[:size_id]] ||= { 
            id: variant_info[:size_id],
            name: variant_info[:size],
            value: variant_info[:size_value].to_i
          }
        end
        all_sizes.values.sort_by{|item| item[:value] }
      end
    end

    def extra_size_start
      site_version.size_settings.size_charge_start rescue 18
    end

    def default_product_sizes
      product_sizes.select{|size| size[:value] < extra_size_start } 
    end

    def extra_product_sizes
      product_sizes.select{|size| size[:value] >= extra_size_start } 
    end

    # colors
    def default_product_colors
      @product_colors ||= begin
        all_colors = {}

        product_variants.each do |variant_info|
          all_colors[variant_info[:color_id]] ||= { 
            id: variant_info[:color_id],
            name: variant_info[:color],
            value: variant_info[:color_value],
            image: variant_info[:image]
          }
        end
        all_colors.values.sort_by{|item| item[:value] }
      end
    end
    
    def extra_product_color_price
      Spree::Price.new(amount: 16, currency: site_version.currency)
    end

    def extra_product_colors
      @extra_product_colors ||= begin
        return [] unless product_properties['color_customization'].to_s.downcase == 'yes'

        product.customisation_colors.map do |option_value|
          {
            id: option_value.id,
            name: option_value.name,
            value: option_value.value,
            image: option_value.image.present? ? option_value.image.url(:small_square) : nil
          }
        end
      end
    end

    def product_moodboard
      Products::ProductMoodboardResource.new(product: product).read
    end

=begin
  def read
    OpenStruct.new({
      name: 'wired cross dress',
      short_description: 'Long, open back, plunging neck bridesmaid dress in black',
      price: OpenStruct.new({ amount: 100, amount_with_discount: 95, currency: 'usd'}),
      images: [
        { url: '', color_id: '' }
      ],
      colors: [
        { id: 123, name: 'red', value: '', image: '' }
      ],
      custom_colors: [
        { id: 123, name: 'red', value: '', image: '' }
      ],
      customisations: [
        { id: 123, name: 'short' }
      ]
    })
  end
=end

  private

end
