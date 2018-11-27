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
          fabrics: OpenStruct.new({
            default: default_product_fabrics,
            extra: extra_product_fabrics,
          }),
          customizations: OpenStruct.new({
            all: available_product_customisations,
            is_free: Spree::Config[:free_customisations]
          }),

          making_options: product_making_options
        })

        # make this property conditional
        if product.layer_cads.present?
          os[:addons] = {
            base_images: cad_images('base'),
            layer_images: cad_images('layer')
          }
        end

      os
    end

    private

      def customisations_available?
        product.discount.blank? || product.discount.sale&.customisation_allowed
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

      def default_product_fabrics
        @default_product_fabrics ||= product.basic_fabrics_with_description
      end

      def extra_product_fabrics
        @extra_product_fabrics ||= product.custom_fabrics_with_description.reject { |x|
          x[:fabric][:name]=="forest-green-heavy-georgette" ||
            x[:fabric][:name]=="bright-mint-corded-lace"
        }
      end

      private def defined_custom_colors
        product.product_color_values.active.custom.map(&:option_value).compact.sort_by(&:presentation)
      end

      # customizations
      def product_customisation_values
        if product&.category&.category == "Sample"
          []
        elsif customisations_available?
          @product_customisation_values ||= JSON.parse(product.customizations)
        else
          []
        end
      end

      def available_product_customisations
        product_customisation_values.map do |value|
          value = value['customisation_value']
          price = site_version.currency == 'AUD' && value['price_aud']  ? value['price_aud'] : value['price']
          OpenStruct.new({
            id: value['id'],
            name: value['presentation'],
            image: value['image_file_name'].present? ? get_customisation_value(value['id'])&.image&.url : 'logo_empty.png',
            display_price: Spree::Money.new(price, currency: site_version.currency, no_cents: true),
            position: value['position'],
            group: value['group']
          })
        end
      end

      def cad_images(type)
        result = product.layer_cads.map do |cad|
          if cad.send("#{type}_image_name")
            {
              name: cad.send("#{type}_image_name"),
              url:  cad.send("#{type}_image").url,
              position: cad.position,
              bit_array: cad.customizations_enabled_for
            }
          else
            nil
          end
        end
        result.compact
      end

      def get_customisation_value(customisation_value_id)
        cv = CustomisationValue.find(customisation_value_id)
      end

      # making options
      def product_making_options
        product.making_options.to_a
      end

    end
end
