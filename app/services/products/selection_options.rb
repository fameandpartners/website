# this designed for product variants selection
# - product side bar with size/color/customizations selection
# usage
#   Products::SelectionOptions.new(product: product).read
module Products
  class SelectionOptions
    attr_reader :site_version, :product

    def initialize(options = {})
      @product      = options[:product]
      #put the layers in order for processing
      @product.layer_cads&.sort!{|layer| layer.position}.reverse!
      @site_version = options[:site_version] || SiteVersion.default
    end

    def read
      #put the layers in order for processing
      product.layer_cads&.sort!{|layer| layer.position}.reverse!

      OpenStruct.new({
        variants: product_variants,

        sizes: OpenStruct.new({
          default: default_product_sizes,
          extra: extra_product_sizes,
          default_extra_price: Spree::Price.new(
            amount: LineItemPersonalization::DEFAULT_CUSTOM_SIZE_PRICE,
            currency: site_version.currency
          )
        }),

        colors: OpenStruct.new({
          default: default_product_colors,
          extra: extra_product_colors,
          default_extra_price: Spree::Price.new(
            amount: LineItemPersonalization::DEFAULT_CUSTOM_COLOR_PRICE,
            currency: site_version.currency
          )
        }),

        customizations: OpenStruct.new({
          all: available_product_customisations,
          incompatibilities: customisations_incompatibility_map,
          is_free: Spree::Config[:free_customisations]
        }),

        addons: {
          base_images: base_images,
          layer_images: layer_images
        },

        making_options: product_making_options
      })
    end

    private

      def customisations_available?
        product.discount.blank? || product.discount.customisation_allowed
      end
      alias_method :extra_sizes_available?, :customisations_available?

      def extra_colors_available?
        customisations_available? && product.color_customization
      end

      def product_variants
        @product_variants ||= Repositories::ProductVariants.new(product_id: product.id).read_all
      end

      # sizes part
      def product_sizes
        @product_sizes ||= begin
          Repositories::ProductSize.new(
            site_version: site_version,
            product: product,
            product_variants: product_variants
          ).read_all
        end
      end

      def default_product_sizes
        product_sizes
      end

      def extra_product_sizes
        []
      end

      def default_product_colors
        @default_product_colors ||= product.basic_colors.sort_by(&:presentation)
      end

      def extra_product_colors
        if extra_colors_available?
          @extra_product_colors ||= defined_custom_colors
        else
          []
        end
      end

      private def defined_custom_colors
        product.product_color_values.active.custom.map(&:option_value).compact.sort_by(&:presentation)
      end

      # TODO Alexey Bobyrev 27 Feb 2017
      # Remove this method as it's not used anymore
      private def legacy_fallback_custom_colors
        basic_product_color_ids = product_variants.map(&:color_id).uniq

        Repositories::ProductColors.read_all.select do |color|
          color.use_in_customisation && !basic_product_color_ids.include?(color.id)
        end.compact.sort_by(&:presentation)
      end
      # eo colors part

      # customizations
      def product_customisation_values
        if customisations_available?
          @product_customisation_values ||= product.customisation_values.by_type(:cut).includes(:incompatibilities)
        else
          []
        end
      end

      def available_product_customisations
        product_customisation_values.map do |value|
          OpenStruct.new({
            id: value.id,
            name: value.presentation,
            image: value.image.present? ? value.image.url : 'logo_empty.png',
            display_price: value.display_price,
            position: value.position,
          })
        end
      end

      def base_images
        result = product.layer_cads.map do |cad|
          if cad.base_image_name
            {
              name: cad.base_image_name,
              url: cad.base_image.url
            }
          else
            nil
          end
        end
        result.compact
      end

      def layer_images
        result = product.layer_cads.map do |cad|
          if cad.layer_image_name
            {
              name: cad.layer_image_name,
              url: cad.layer_image.url
            }
          else
            nil
          end
        end
        result.compact
      end

      def customisations_incompatibility_map
        product_customisation_values.inject({}) do |hash, value|
          hash[value.id] = value.incompatibilities.map(&:incompatible_id)
          hash
        end
      end

      # making options
      def product_making_options
        product.making_options.to_a
      end

    end
end
