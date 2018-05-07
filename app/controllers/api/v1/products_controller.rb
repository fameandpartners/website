MIN_CM = 147
MAX_CM = 193
MIN_INCH = 58
MAX_INCH = 76

PRODUCT_IMAGE_SIZES = [:original, :product]

CARE_DESCRIPTION = "<p>Professional dry-clean only. <br />See label for further details.</p>"

module Api
  module V1
    class ProductsController < ApplicationController
      respond_to :json

      def show
        product = Spree::Product
          .not_deleted
          .includes(:product_properties)
          .find(params[:id])

        colors = product.product_color_values
          .includes(:option_value)
          .active

        fabrics = product
          .fabric_products
          .includes(fabric: [:option_fabric_color_value, :option_value])

        sizes = product.option_types.find_by_name('dress-size').option_values
        customizations = JSON.parse!(product.customizations)

        slow_making_option = product.making_options.find(&:slow_making?)
        product_fabric = product.property('fabric')
        product_fit = product.property('fit')
        product_size = product.property('size')

        images = product
          .images
          .includes(:viewable)

        product_viewmodel = {
          id: product.id,
          productId: product.id,
          cartId: product.master.id,
          returnDescription: 'Shipping is free on your customized item. <a href="/faqs#collapse-returns-policy" target="_blank">Learn more</a>',
          deliveryTimeDescription: slow_making_option.try(:display_delivery_period),

          curationMeta: {
            name: product.name,
            description: product.description,
            keywords: product.meta_keywords,
            styleDescription: product.property('style_notes'),
            permaLink: product.name.parameterize
          },
          isAvailable: product.is_active?,
          price: (product.price_in(current_site_version.currency).amount * 100).to_i,
          paymentMethods: {
            afterPay: current_site_version.is_australia?
          },
          size: {
            minHeightCm: MIN_CM,
            maxHeightCm: MAX_CM,
            minHeightInch: MIN_INCH,
            maxHeightInch: MAX_INCH,
            sizeChart: product.size_chart,
          },
          components: [
            fabrics.empty? ? colors.map {|c| map_color(c, product_fabric) }  : fabrics.map { |f| map_fabric(f) },

            sizes.map {|s| map_size(s) },

            customizations.map {|c| map_customization(c) },

            product.making_options
              .reject { |making| making.slow_making? }
              .map { |making| map_making(making) },

            [
              {
                cartId: 0,
                code: 'free_returns',
                title: "Free returns",
                componentTypeId: :Return,
                componentTypeCategory: :Return,
                price: 0,
                isProductCode: false,
                isRecommended: false,
                type: :return,
                meta: {
                  sortOrder: 1,
                  returnDescription: 'Shipping and returns are free. <a href="/faqs#collapse-returns-policy" target="_blank">Learn more</a>'
                },
                incompatibleWith: { allOptions: [] },
              }
            ]
          ].flatten.compact,

          groups: [
            colors.length > 0 && fabrics.empty? && {
              id: 120,
              title: 'Color',
              changeButtonText: "Change",
              slug: 'color',
              sectionGroups: [
                {
                  title: 'Color',
                  slug: 'color',
                  previewType: :image,
                  sections: [
                    {
                      componentTypeId: :Colour,
                      componentTypeCategory: :Colour,
                      title: "Select your color",
                      options: colors.map {|c| { code: c.option_value.name, isDefault: false, parentOptionId: nil } },
                      selectionType: :RequiredOne,
                    }]
                }
              ]
            } || nil,

            fabrics.length > 0 && {
              id: 121,
              title: 'Fabric',
              changeButtonText: "Change",
              slug: 'fabric',
              sectionGroups: [
                {
                  title: "Color & Fabric",
                  slug: 'fabric',
                  previewType: :image,
                  sections: [
                    {
                      componentTypeId: :Fabric,
                      componentTypeCategory: :Fabric,
                      title: "Select your color & fabric",
                      selectionType: :RequiredOne,
                      options: fabrics.map {|f| { code: f.fabric.name, isDefault: false, parentOptionId: nil } },
                    }]
                }
              ]
            } || nil,

            customizations.length > 0 && {
              id: 122,
              title: 'Customize',
              changeButtonText: "Change",
              slug: 'customize',
              sectionGroups: [
                {
                  title: "Customize",
                  slug: 'customize',
                  previewType: :cad,
                  sections: [
                    {
                      componentTypeId: :Customisations,
                      componentTypeCategory: :Customisations,
                      title: "Select your customizations",
                      options: customizations.map {|f| { code: f['customisation_value']['name'], isDefault: false, parentOptionId: nil } },
                      selectionType: customizations.length === 3 ? :OptionalOne : :OptionalMultiple,
                    }
                  ]
                }
              ]
            } || nil,

            sizes.length > 0 && {
              id: 123,
              title: 'Size',
              changeButtonText: "Select",
              sortOrder: 9,
              slug: 'size',
              sectionGroups: [
                {
                  title: "Size",
                  slug: 'size',
                  previewType: :image,
                  sections: [
                    {
                      componentTypeId: 'heightAndSize',
                      componentTypeCategory: :Size,
                      title: "Select your height and size",
                      selectionType: :RequiredOne,
                      options: sizes.map {|s| { code: s.name, isDefault: false, parentOptionId: nil } },
                    }]
                }]
            } || nil,
          ].flatten.compact,

          media: images
            .reject { |i| i.attachment_file_name.downcase.include?('crop') }
            .map {|image| map_image(image, fabrics, colors, product_fit, product_size) },

          layerCads: [
            product.layer_cads.empty? ? customizations.map {|c| map_cad_from_customization(c)} : product.layer_cads.map {|lc| map_layer_cad(lc, customizations) }
          ].flatten.compact,
        }
        respond_with product_viewmodel.to_json
      end

      private

      def map_cad_from_customization(c)
        {
          url: customization_image(c['customisation_value']),
          width: -1,
          height: -1,
          sortOrder: c['customisation_value']['position'],
          type: :layer,
          components: [c['customisation_value']['name']]
        }
      end

      def map_layer_cad(lc, customizations)
        {
          url: lc.base_image_name ? lc.base_image.url : lc.layer_image.url,
          width: lc.width,
          height: lc.height,
          sortOrder: lc.position,
          type: lc.base_image_name ? :base : :layer,
          components: lc.customizations_enabled_for.map.with_index {|active, index|
            active ? customizations[index]['customisation_value']['name'] : nil
          }.compact
        }
      end

      def map_image(image, fabrics, colors, product_fit, product_size) 
        option = nil

        if image.viewable_type == "FabricsProduct"
          fabric = fabrics.find { |f| f.id == image.viewable_id}
          option = fabric&.fabric&.name
        elsif image.viewable_type == "ProductColorValue"
          color = colors.find { |f| f.id == image.viewable_id}
          option = color&.option_value&.name
        end

        {
          type: :photo,
          fitDescription: fixup_fit(product_fit),
          sizeDescription: product_size,
          src: PRODUCT_IMAGE_SIZES.map {|image_size|
            geometry = Paperclip::Geometry.parse(image.attachment.styles['product'].geometry)

            {
              name: image_size,
              width: image_size == :original ? image.attachment_width : geometry.width,
              height: image_size == :original ? image.attachment_height : geometry.height,
              url: image.attachment.url(image_size),
            }
          },
          sortOrder: image.position,
          options: [
            option
          ].compact
        }
      end

      def map_customization(c)
        {
          cartId: c['customisation_value']['id'],
          code: c['customisation_value']['name'],
          isDefault: false,
          title: c['customisation_value']['presentation'],
          componentTypeId: :LegacyCustomisation,
          componentTypeCategory: :LegacyCustomisation,
          price: (BigDecimal.new(c['customisation_value']['price']) * 100).to_i,
          isProductCode: true,
          isRecommended: false,
          type: :LegacyCustomisation,
          meta: {
            sortOrder: c['customisation_value']['position'],
            image: {
              url: customization_image(c['customisation_value']),
              width: -1,
              height: -1
            }
          },
          incompatibleWith: { allOptions: [] },
        }
      end
      
      def map_making(making)
        {
          cartId: making.id,
          code: making.option_type,
          isDefault: false,
          title: making.name,
          componentTypeId: :Making,
          componentTypeCategory: :Making,
          price: (making.price*100).to_i,
          isProductCode: false,
          isRecommended: false,
          type: :Making,
          meta: {
            sortOrder: making.super_fast_making? ? 1 : making.fast_making? ? 2 : 3,
            deliveryTimeDescription: making.description,
            deliveryTimeRange: making.display_delivery_period
          },
          incompatibleWith: { allOptions: [] },
        }
      end

      def map_fabric(f)
        {
          cartId: f.fabric.id,
          code: f.fabric.name,
          isDefault: false,
          title: f.fabric.presentation,
          componentTypeId: :Fabric,
          componentTypeCategory: 'ColorAndFabric',
          price: f.recommended ? 0 : (f.fabric.price_in(current_site_version.currency) * 100).to_i,
          isProductCode: true,
          isRecommended: f.recommended,
          type: :Fabric,
          meta: {
            sortOrder: f.fabric.option_fabric_color_value.position, #TODO
            # hex: c.option_value.value,
            
            image: {
              url: f.fabric.image_url,
              width: 0,
              height: 0,
            },

            colorId: f.fabric.option_value.id,
            colorCode: f.fabric.option_value.name,

            materialTitle: f.fabric.material,
            colorTitle: f.fabric.option_value.presentation,

            careDescription: CARE_DESCRIPTION,
            fabricDescription: f.description,
          },
          img: f.fabric.image_url,
          incompatibleWith: f.recommended ? {} : { allOptions: ['fast_making'] },
        }
      end

      def map_color(c, product_fabric)
        {
          cartId: c.option_value.id,
          code: c.option_value.name,
          isDefault: false,
          title: c.option_value.presentation,
          componentTypeId: :Colour,
          componentTypeCategory: :Colour,
          price: c.custom ? (LineItemPersonalization::DEFAULT_CUSTOM_COLOR_PRICE * 100).to_i : 0,
          isProductCode: true,
          isRecommended: !c.custom,
          type: :Colour,
          meta: {
            sortOrder: c.option_value.position,
            hex: c.option_value.value&.include?('#') ? c.option_value.value : nil,
            image: {
              url: c.option_value.value&.include?('#') ? color_image(c.option_value.image_file_name) : color_image(c.option_value.value),
              width: 0,
              height: 0,
            },

            careDescription: CARE_DESCRIPTION,
            fabricDescription: product_fabric,
          },
          incompatibleWith: c.custom ? { 'allOptions': ['fast_making'] } : { allOptions: [] },
        }
      end

      def map_size(s)
        {
          cartId: s.id,
          code: s.name,
          isDefault: false,
          title: s.presentation,
          componentTypeId: :Size,
          componentTypeCategory: :Size,
          price: 0,
          isProductCode: false,
          isRecommended: false,
          type: :Size,
          meta: {
            sortOrder: s.position,
            sizeUs: s.name.split("/")[0],
            sizeAu: s.name.split("/")[1],
          },
          incompatibleWith: { allOptions: [] },
        }
      end

      def color_image(image_file_name)
        return nil unless image_file_name

        "#{configatron.asset_host}/assets/product-color-images/#{image_file_name}"
      end

      def customization_image(customization)
        return nil unless customization['image_file_name']

        "#{configatron.asset_host}/system/images/#{customization['id']}/original/#{customization['image_file_name']}"
      end

      def fixup_fit(fit)
        return nil if fit.blank?

        fit
          .gsub(/:(?=[^\s])/, ": ")
          .gsub(/ +,/, ', ')
          .gsub(/cm(?=[^\s])/, 'cm, ')
          .gsub(/in(?=[^\s])/, 'in, ')
          .gsub(/inch(?=[^\s])/, 'inch, ')
          .gsub(/are:(?=[^\n])/, "are: \n")
      end
      def map_option(c)
        {
          code: c.name,
          isDefault: false,
          parentOptionId: nil
        }
      end

    end
  end
end
