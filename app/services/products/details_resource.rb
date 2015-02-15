# extract all product details here
# Products::ProductDetailsResource.new(
#   site_version: [ sizes / prices different for them ]
#   slug      - 'dress-naomi-459'
#   permalink - 'naomi' or 'sweetheart_hi_low'
#   product   - obsoleted! support legacy only
#   color_name - 'dress-naomi-459/red' - red part
#   
#
class Products::DetailsResource
  attr_reader :site_version, :product, :color_name

  def initialize(options = {})
    if options[:slug].blank? && options[:permalink].blank? && options[:product].blank? 
      raise ArgumentError.new('have no product identificators')
    end

    @site_version     = options[:site_version] || SiteVersion.default
    @color_name       = options[:color_name]
    @product          = find_product!(options[:slug], options[:permalink], options[:product])
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
    Rails.cache.fetch(cache_key, expires_in: cache_expiration_time, force: Rails.env.development?) do
      # product details
      OpenStruct.new({
        id: product.id,
        master_id: product.master.try(:id),
        is_active: true, # fake, implement this later
        sku:  product.sku,
        name: product.name,
        short_description: product_short_description,
        description: product.description,
        permalink: product.permalink,
        images: product_images,
        default_image: default_product_image,
        price:    product_price,
        discount: product_discount,
        recommended_products: recommended_products
      })
    end
  end

=begin
  def read
    Rails.cache.fetch(cache_key, expires_in: cache_expiration_time, force: Rails.env.development?) do
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
=end

  private

    # options[:product_slug], options[:product_id], options[:product])
    # slug      - dress-naomi-459
    # permalink - sweetheart_hi_low
    def find_product!(slug, permalink, candidate)
      scope = Spree::Product.includes(:variants_including_master, :taxons)

      result = if candidate.present?
        scope.where(id: candidate.id).first
      elsif slug.present?
        slug_id = get_product_id_from_slug(slug)
        scope.where(id: slug_id).first
      elsif permalink
        scope.where(permalink: permalink).first
      end

      result.present? ? result : raise(Errors::ProductNotFound)
    end

    def get_product_id_from_slug(slug)
      result = slug.to_s.match(/(\d)+$/)
      return result[0] if result.present?
      raise ArgumentError.new('invalid product slug')
    end

    # images
    def product_images
      Repositories::ProductImages.new(
        product: product
      ).read_all
    end

    def default_product_image
      product_images.first.try(:large) || 'noimage/product.png'
    end

    # properties part
    # maybe move it to repo?
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

    def product_price
      Repositories::ProductPrice.new(site_version: site_version, product: product).read
    end

    def product_discount
      Repositories::Discount.get_product_discount(product.id)
    end

    def recommended_products
      Products::RecommendedProducts.new(product: product, limit: 4).read.map do |recommended_product|
        OpenStruct.new(
          id: recommended_product.id,
          name: recommended_product.name,
          price: Repositories::ProductPrice.new(site_version: site_version, product: product).read,
          image: Repositories::ProductImages.new(product: recommended_product).read
        )
      end
    end
end
