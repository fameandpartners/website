module Products
  class Complementary
    include PathBuildersHelper

    attr_reader :product, :site_version, :presenter

    delegate :id, :name, to: :product
    delegate :prices, to: :presenter

    def initialize(product: nil, site_version: nil)
      @product      = product
      @product['image_link'] = get_product_image_link
      @product['relative_url_path'] = collection_product_path(@product)
      @price        = product.site_price_for(site_version || SiteVersion.default)
    end

    private

    # NOTE: Nav Samra --- 10/30/17
    #
    #   This is a slightly stripped down copy of collection_product_path
    #   from the PathBuildersHelper module (same minus site prefix, since
    #   the new PDP is handling relative paths).
    #
    #
    def collection_product_path(product, options = {})
      product_type        = options.delete(:product_type) || 'dress'
      path_parts          = ['dresses']
      locale              = I18n.locale.to_s.downcase.underscore.to_sym

      if product.is_a?(Tire::Results::Item) && product[:urls][locale].present?
        path_parts << "#{product_type}-#{product[:urls][locale]}"
      else
        path_parts << "#{product_type}-#{descriptive_url(product)}"
      end

      color_name = product.respond_to?(:color) && (product.color || {})[:name]

      if options[:color].nil? && color_name.present?
        options.merge!({ color: color_name })
      end

      build_url(path_parts, options)
    end

    def get_product_image_link
      Repositories::ProductImages.new(product: product).read.product
    end
  end
end
