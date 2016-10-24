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

  def read
    Rails.cache.fetch([site_version, product]) do
      Products::Presenter.new({
        id:                                  product.id,
        master_id:                           product.master.try(:id),
        sku:                                 product.sku,
        name:                                product.name,
        description:                         product.description,
        permalink:                           product.permalink,
        is_active:                           product.is_active?,
        is_deleted:                          product.deleted?,
        height_customisable:                 product.height_customisable?,
        images:                              product_images.read_all,
        default_image:                       product_images.default,
        price:                               product_price,
        discount:                            product_discount,
        taxons:                              product_taxons,
        # page#show specific details
        recommended_products:                recommended_products,
        variants:                            product.variants,
        related_outerwear:                   related_outerwear,
        available_options:                   product_selection_options,
        moodboard:                           product_moodboard,
        fabric:                              product_fabric,
        fit:                                 product_fit,
        size:                                product_size,
        style_notes:                         product_style_notes,
        render3d_images:                     product_render3d_images,
        size_chart:                          product.size_chart,
        fast_making:                         product.fast_making,
        standard_days_for_making:            product.standard_days_for_making,
        customised_days_for_making:          product.customised_days_for_making,
        default_standard_days_for_making:    product.default_standard_days_for_making,
        default_customised_days_for_making:  product.default_customised_days_for_making
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

    def product_render3d_images
      @product_render3d_images ||= \
        if product_render_3d?
          Render3d::Image.where(product_id: product.id)
        else
          []
        end
    end

    # properties part
    def product_fabric
      Rails.cache.fetch([product, 'product-property', 'fabric']) { product.property('fabric') }
    end

    def product_fit
      Rails.cache.fetch([product, 'product-property', 'fit']) { product.property('fit') }
    end

    def product_size
      Rails.cache.fetch([product, 'product-property', 'size']) { product.property('size') }
    end

    def product_style_notes
      Rails.cache.fetch([product, 'product-property', 'style-notes']) { product.property('style_notes') }
    end

    def product_render_3d?
      Rails.cache.fetch([product, 'product-property', 'render-3d']) { product.property('render-3d') == 'true' }
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
