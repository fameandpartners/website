# extract all product details here
# Products::ProductDetailsResource.new(
#   site_version: [ sizes / prices different for them ]
#   slug      - 'dress-naomi-459'
#   permalink - 'naomi' or 'sweetheart_hi_low'
#   product   - obsoleted! support legacy only
#
class Products::DetailsResource
  META_DESCRIPTION_MAX_SIZE = 160

  attr_reader :site_version, :product

  def initialize(options = {})
    if options[:slug].blank? && options[:permalink].blank? && options[:product].blank?
      raise ArgumentError.new('have no product identificators')
    end

    @site_version     = options[:site_version] || SiteVersion.default
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
      Products::Presenter.new({
        id:                 product.id,
        master_id:          product.master.try(:id),
        sku:                product.sku,
        name:               product.name,
        short_description:  product_short_description,
        description:        product.description,
        permalink:          product.permalink,
        is_active:          product.is_active?,
        images:             product_images.read_all,
        default_image:      product_images.default,
        price:              product_price,
        discount:           product_discount,
        # page#show specific details
        recommended_products: recommended_products,
        available_options:  product_selection_options,
        moodboard:          product_moodboard,
        fabric:             product_fabric,
        style_notes:        product_style_notes,
        size_chart:         product.size_chart
      })
    end
  end

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
      @product_images ||= Repositories::ProductImages.new(product: product)
    end

    # properties part
    def product_properties
      @product_properties ||= Repositories::ProductProperties.new(product: product)
    end

    def product_short_description
      if !product.meta_description.blank?
        product.meta_description
      else
        sanitized_description = ActionView::Base.full_sanitizer.sanitize(product.description)
        sanitized_description.truncate(META_DESCRIPTION_MAX_SIZE)
      end
    end

    def product_fabric
      product_properties['fabric']
    end

    def product_style_notes
      product_properties['style_notes']
    end

    def product_price
      Repositories::ProductPrice.new(site_version: site_version, product: product).read
    end

    def product_discount
      Repositories::Discount.get_product_discount(product.id)
    end

    def product_moodboard
      Repositories::ProductMoodboard.new(product: product).read
    end

    def recommended_products
      Products::RecommendedProducts.new(product: product, limit: 4).read.map do |recommended_product|
        image = Repositories::ProductImages.new(product: recommended_product).read(cropped: true)
        color = Repositories::ProductColors.read(image.try(:color_id))

        OpenStruct.new(
          id: recommended_product.id,
          name: recommended_product.name,
          price: Repositories::ProductPrice.new(site_version: site_version, product: recommended_product).read,
          discount: Repositories::Discount.get_product_discount(recommended_product.id),
          image: image,
          color: color
        )
      end
    end

    def product_selection_options
      Products::SelectionOptions.new(site_version: site_version, product: product).read
    end
end
