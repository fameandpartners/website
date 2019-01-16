# this designed for product variants selection
# - product side bar with size/color/customizations selection
# usage
#   Products::SelectionOptions.new(product: product).read
module Products
  class SelectionOptions
    attr_reader :site_version, :product

    def initialize(options = {})
      @product      = options[:product]
      @site_version = options[:site_version] || SiteVersion.default
    end

    def read
      #put the layers in order for processing
      @product.layer_cads&.sort!{|layer| layer.position}.reverse!
      os =
        OpenStruct.new({
          sizes: product_sizes,
          colors: product_colors,
          fabrics: product_fabrics,
          customizations: available_product_customisations,
          making_options: product_making_options
        })
      os
    end

    private

      def customisations_available?
        product.discount.blank? || product.discount.sale&.customisation_allowed
      end
      alias_method :extra_sizes_available?, :customisations_available?

      # sizes part
      def product_sizes
        @product_sizes ||= product.option_types.find_by_name('dress-size')&.option_values || []
      end

      def product_colors
        product.product_color_values.active.map(&:option_value).compact.sort_by(&:presentation)
      end

      def product_fabrics
        product.fabrics.compact.sort_by(&:presentation)
      end

      # customizations
      def available_product_customisations
        product.customisation_values.map do |value|
          price = value.price_in(site_version.currency)
          OpenStruct.new({
            id: value.id,
            name: value.presentation,
            image: value.image_file_name.present? ? value.image&.url : 'logo_empty.png',
            display_price: Spree::Money.new(price, currency: site_version.currency, no_cents: true),
            position: value.position,
          })
        end
      end

      # making options
      def product_making_options
        product.making_options.to_a
      end

    end
end
