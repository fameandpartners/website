# extract all product details here
# Products::ProductDetailsResource.new(
#   site_version: [ sizes / prices different for them ]
#   slug      - 'dress-naomi-459'
#   permalink - 'naomi' or 'sweetheart_hi_low'
#   product   - obsoleted! support legacy only
#
class Products::DetailsResource
  RECOMMENDED_PRODUCTS_LIMIT = 4
  RELATED_OUTERWEAR_LIMIT = 4

  attr_reader :site_version, :product

  def initialize(options = {})
    if options[:slug].blank? && options[:permalink].blank? && options[:product].blank?
      raise ArgumentError.new('have no product identificators')
    end

    @site_version = options[:site_version] || SiteVersion.default
    @product      = find_product!(options[:slug], options[:permalink], options[:product])
  end

  def cache_key
    "product-details-#{ site_version.try(:permalink) }-#{ product.permalink }"
  end

  def cache_expiration_time
    configatron.cache.expire.long
  end

  def read
    Rails.cache.fetch(cache_key, expires_in: cache_expiration_time, force: Rails.env.development?) do
      Products::Presenter.new({
        id:                          product.id,
        master_id:                   product.master.try(:id),
        sku:                         product.sku,
        name:                        product.name,
        short_description:           product_short_description,
        description:                 product.description,
        permalink:                   product.permalink,
        is_active:                   product.is_active?,
        is_deleted:                  product.deleted?,
        images:                      product_images.read_all,
        default_image:               product_images.default,
        price:                       product_price,
        discount:                    product_discount,
        taxons:                      product_taxons,
        # page#show specific details
        recommended_products:        recommended_products,
        related_outerwear:           related_outerwear,
        available_options:           product_selection_options,
        moodboard:                   product_moodboard,
        fabric:                      product_fabric,
        fit:                         product_fit,
        size:                        product_size,
        style_notes:                 product_style_notes,
        size_chart:                  product.size_chart,
        fast_making:                 product.fast_making,
        standard_days_for_making:    product.standard_days_for_making,
        customised_days_for_making:  product.customised_days_for_making
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
      slug.to_s.match(/(\d)+$/) { |result| result[0] }
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
      product.meta_description.blank? ? product.description : product.meta_description
    end

    def product_fabric
      product_properties['fabric']
    end

    def product_fit
      product_properties['fit']
    end

    def product_size
      product_properties['size']
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
      Products::RecommendedProducts.new(product: product, limit: RECOMMENDED_PRODUCTS_LIMIT).read.map do |recommended_product|
        Products::Related.new(product: recommended_product, site_version: site_version)
      end
    end

    def related_outerwear
      # TODO: 27/08/2015 remove this after CreateSpreeProductRelatedOuterwear migration was execute in production.
      return [] unless ActiveRecord::Base.connection.table_exists?(:spree_product_related_outerwear)

      product.related_outerwear.first(RELATED_OUTERWEAR_LIMIT).map do |recommended_product|
        Products::Related.new(product: recommended_product, site_version: site_version)
      end
    end

    def product_selection_options
      Products::SelectionOptions.new(site_version: site_version, product: product).read
    end

    def product_taxons
      product.taxons.collect { |taxon| Taxons::Presenter.new(spree_taxon: taxon) }
    end
end
