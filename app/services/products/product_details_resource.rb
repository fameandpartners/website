# DEPRECATION WARINING! use Products::DetailsResource instead
# please, extract not user dependable data receiving to repo
class Products::ProductDetailsResource
  attr_reader :site_version, :product, :color_name

  def initialize(options = {})
    warn 'DEPRECATED, Invalid use of (Products::ProductDetailsResource) use Products::DetailsResource.'
    @site_version     = options[:site_version]
    @product          = options[:product]
    @color_name       = options[:color_name]
  end

  def cache_key
    "product-details-#{ site_version.try(:permalink) }-#{ product.permalink }"
  end

  def cache_expiration_time
    return configatron.cache.expire.quickly if Rails.env.development?
    return configatron.cache.expire.quickly if Rails.env.staging?
    return configatron.cache.expire.long
  end

  def read
    Rails.cache.fetch(cache_key, expires_in: cache_expiration_time, force: true) do

      # load often used associations
      @product = product_with_associations(@product)

      # product details
      OpenStruct.new({
        id: product.id,
        master_id: product.master.try(:id),
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
        discount: product_discount,
        free_customisations: Spree::Config[:free_customisations],
        sizes: default_product_sizes,
        extra_sizes: extra_product_sizes,
        colors: default_product_colors,
        extra_colors: extra_product_colors,
        extra_color_price: extra_product_color_price,
        customisations: available_product_customisations,
        customisations_incompatibility_map: customisations_incompatibility_map,
        variants: product_variants,
        moodboard: product_moodboard,
        url: product_url,
        path: product_path,
        selected_color: selected_product_color,
        preorder: product_properties['preorder']
      })
    end
  end

  private

    def product_variants
      @product_variants ||= Products::VariantsReceiver.new(product).available_options
    end

    def product_with_associations(product_candidate)
      Spree::Product.includes(:variants_including_master, :taxons).find(product_candidate.id)
    end

    def default_product_image
      product_images.first.try(:large) || 'noimage/product.png'
    end

    # todo: add sort by preferred color & position
    def product_images
      Repositories::ProductImages.new(
        product: product
      ).read_all
    end

    def product_price
      @product_price ||= product.site_price_for(site_version)
    end

    def product_discount
      product.discount
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
      text = text.to_s.gsub(/(prom|formal)(\s)/i, '')
      ActionView::Base.full_sanitizer.sanitize(text.to_s)
    rescue
      I18n.t('product_has_no_description')
    end

    def product_description
      product.description
    end

    def product_path
      @product_path ||= begin
        path_parts      = [site_version.permalink, 'dresses']
        path_parts.push([product.name.parameterize, product.id].join('-'))
        # if colour present?
        # path_part.push(colour)
        "/" + path_parts.join('/')
      end
    end

    def product_url
      "#{configatron.host}#{product_path}"
    end

    # sizes
    def available_sizes_values
      [0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26]
    end

    def product_sizes
      @product_sizes ||= begin
        all_sizes = {}
        product_variants.each do |variant_info|
          if available_sizes_values.include?(variant_info[:size_value].to_i)
            all_sizes[variant_info[:size_id]] ||= {
              id: variant_info[:size_id],
              name: variant_info[:size],
              title: "#{ site_version.size_settings.locale_code } #{ variant_info[:size_presentation].to_i }",
              value: variant_info[:size_value].to_i,
              size_details_attributes: get_size_details(variant_info[:size_value])
            }
          end
        end
        all_sizes.values.sort_by{|item| item[:value] }
      end
    end

    def get_size_details(size)
      if site_version.is_australia?
        {
          unit_code:   site_version.size_settings.locale_unit_code,
          unit_symbol: site_version.size_settings.locale_unit_symbol,
          locale_code: site_version.size_settings.locale_code,
          attributes: SIZE_ATTRIBUTES.find_by_au_name(size.to_s)
        }
      else
        {
          unit_code:   site_version.size_settings.locale_unit_code,
          unit_symbol: site_version.size_settings.locale_unit_symbol,
          locale_code: site_version.size_settings.locale_code,
          attributes: SIZE_ATTRIBUTES.find_by_us_name(size.to_s)
        }
      end
    end

    def extra_size_start
      site_version.size_settings.size_charge_start rescue 18
    end

    def default_size_start
      site_version.size_settings.size_start rescue 4
    end

    def default_size_end
      site_version.size_settings.size_end rescue 26
    end

    # default sizes - has no additional charge
    def default_product_sizes
      if product_has_free_extra_sizes?
        product_sizes.select{|size| size[:value] >= default_size_start && size[:value] <= default_size_end }
      else
        product_sizes.select{|size| size[:value] >= default_size_start && size[:value] < extra_size_start }
      end
    end

    # extra sizes - has extra pay
    def extra_product_sizes
      return [] if product_has_free_extra_sizes?
      sizes = product_sizes.select{|size| size[:value] >= extra_size_start && size[:value] <= default_size_end }
      sizes.map {|size| size[:extra_price] = true; size }
    end

    def product_has_free_extra_sizes?
      @product_has_free_extra_sizes ||= product.taxons.where(:name =>"Plus Size").exists?
    end

    # colors
    def selected_product_color
      @selected_product_color ||= begin
        if color_name.present? && (color = Spree::OptionValue.colors.find_by_name(color_name)).present?
          OpenStruct.new(id: color.id, presentation: color.presentation, name: color.name)
        elsif product_images.present?
          image = product_images.first
          OpenStruct.new(id: image.color_id, presentation: image.color, name: image.color)
        else
          OpenStruct.new({})
        end
      end
    end

    def default_product_colors
      @product_colors ||= begin
        all_colors = {}

        product_variants.each do |variant_info|
          all_colors[variant_info[:color_id]] ||= {
            id: variant_info[:color_id],
            name: variant_info[:color],
            title: variant_info[:color_presentation],
            value: variant_info[:color_value],
            image: variant_info[:image],
            selected: selected_product_color.id == variant_info[:color_id]
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
            title: option_value.presentation,
            value: option_value.value,
            image: option_value.image.present? ? option_value.image.url(:small_square) : nil,
            selected: option_value.id == selected_product_color.id
          }
        end
      end
    end

    def product_moodboard
      Repositories::ProductMoodboard.new(product: product).read
    end

    def product_customisation_values
      JSON.parse(product.customizations, object_class: OpenStruct) #customisation_values.includes(:incompatibilities, :discounts => :sale)
    end

    def available_product_customisations
      product_customisation_values.map do |value|
        product_customisation_values
        OpenStruct.new({
          id: value.id,
          name: value.presentation,
          image: value.image.present? ? value.image.url : 'logo_empty.png',
          price: value.price,
          display_price: Spree::Money.new(value.price., currency: product.making_options.first.currency, no_cents: true),
          discount: value.discounts.detect{ |discount| discount.sale.blank? || discount.sale.active? }
        })
      end
    end

    def customisations_incompatibility_map
      result = {}
      product_customisation_values.each do |value|
        result[value.customisation_value.id] = value.customisation_value.incompatibilities.map(&:incompatible_id)
      end
      result
    end
end
