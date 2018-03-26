AU_SIZES = [4, 6, 8, 10, 12, 14, 16, 18, 20, 22, 24, 26]
US_SIZES = [0, 2, 4, 6, 8, 10, 12, 14, 16, 18, 20, 22]
INCH_SIZES = [
  {id: 0, ft: 4, inch: 10, totalInches: 58},
  {id: 1, ft: 4, inch: 11, totalInches: 59},
  {id: 2, ft: 5, inch: 0, totalInches: 60},
  {id: 3, ft: 5, inch: 1, totalInches: 61},
  {id: 4, ft: 5, inch: 2, totalInches: 62},
  {id: 5, ft: 5, inch: 3, totalInches: 63},
  {id: 6, ft: 5, inch: 4, totalInches: 64},
  {id: 7, ft: 5, inch: 5, totalInches: 65},
  {id: 8, ft: 5, inch: 6, totalInches: 66},
  {id: 9, ft: 5, inch: 7, totalInches: 67},
  {id: 10, ft: 5, inch: 8, totalInches: 68},
  {id: 11, ft: 5, inch: 9, totalInches: 69},
  {id: 12, ft: 5, inch: 10, totalInches: 70},
  {id: 13, ft: 5, inch: 11, totalInches: 71},
  {id: 14, ft: 6, inch: 0, totalInches: 72},
  {id: 15, ft: 6, inch: 1, totalInches: 73},
  {id: 16, ft: 6, inch: 2, totalInches: 74},
  {id: 17, ft: 6, inch: 3, totalInches: 75},
  {id: 18, ft: 6, inch: 4, totalInches: 76}
]
MIN_CM = 147
MAX_CM = 193

PRODUCT_IMAGE_SIZES = [:original, :product]

module Api
  module V1
    class ProductsController < ApplicationController
      respond_to :json

      def show
        product = Spree::Product.find(params[:id])

        colors = product.product_color_values
        fabrics = product.fabrics
        sizes = product.option_types.find_by_name('dress-size').option_values
        customisations = JSON.parse!(product.customizations)


        produt_viewmodel = {
          id: product.id,
          sku: product.master.sku,
          name: product.name,
          description: product.description,
          garmentCareDescription: "
            <p>Professional dry-clean only. <br />
            See label for further details.</p>
          ",
          styleDescription: find_product_property(product, 'style_notes'),
          fabricDescription: find_product_property(product, 'fabric'),
          fitDescription: find_product_property(product, 'fit'),
          productDetailsDescription: find_product_property(product, 'product_details'),
          sizeDescription: find_product_property(product, 'size'),

          returnDescription: "Shipping is free on your customized item. <a href="">Learn more</a>",
          deliveryTimeDescription: "Estimated delivery 6 weeks.",


          #deliveryTime: "Estimated delivery 2-3 weeks.",
          #returnPolicy: "Shipping and returns are free.  <a href="">Learn more</a>",


          meta: {
            keywords: product.meta_keywords,
            # description: '',
            permaLink: product.permalink
          },
          price: (product.price_in(current_site_version.currency).amount * 100).to_i,
          paymentMethods: {
            afterPay: current_site_version.is_australia?
          },
          size: {
            minHeightCm: MIN_CM,
            maxHeightCm: MAX_CM,
            inchSelection: INCH_SIZES.map {|i| i[:totalInches]},
            sizeChart: product.size_chart,
          },
          components: [
            colors.map {|c|
              {
                code: c.option_value.name,
                name: c.option_value.presentation,
                type: :color,
                sort_order: c.option_value.position,
                hex: c.option_value.value,
                img: c.option_value.image_file_name,
                incompatibilities: c.custom ? ['express_making'] : [],
                is_recommended: !c.custom,
                price: c.custom ? (LineItemPersonalization::DEFAULT_CUSTOM_COLOR_PRICE*100).to_i : 0
              }
            },

            fabrics.map {|c|
              {
                code: c.option_value.name,
                name: c.option_value.presentation,
                type: :fabric,
                sort_order: c.option_value.position,
                hex: c.option_value.value,
                img: c.option_value.image_file_name,
                incompatibilities: c.custom ? ['express_making'] : [],
                is_recommended: !c.custom
              }
            },

            sizes.map {|c|
              {
                code: c.name,
                name: c.presentation,
                type: :size,
                sort_order: c.position,
                # price: c.custom ? (LineItemPersonalization::DEFAULT_CUSTOM_SIZE_PRICE*100).to_i : 0,
                incompatibilities: []
              }
            },

            customisations.map {|c|
              {
                code: c['customisation_value']['name'],
                name: c['customisation_value']['presentation'],
                type: :customisation,
                sort_order: c['customisation_value']['position'],
                img: c['customisation_value']['image_file_name'],
                incompatibilities: ['express_making'],
                price: (BigDecimal.new(c['customisation_value']['price']) * 100).to_i
              }
            },
            [
              {
                code: 'express_making',
                name: "Express Making",
                delivery_time: '2 weeks',
                type: :making,
                sort_order: 1,
              }
            ]
          ].flatten,
          groups: [
            sizes.length > 0 && {
              name: 'Size',
              change_button_text: "Select",
              components: sizes.map(&:name)
            } || nil,

            colors.length > 0 && {
              name: 'Color',
              change_button_text: "Change",
              components: colors.map {|c| c.option_value.name}
            } || nil,

            fabrics.length > 0 && {
              name: 'Fabric',
              change_button_text: "Change",
              components: fabrics.map {|f| f.option_value.name}
            } || nil,

            customisations.length > 0 && {
              name: 'Customize',
              change_button_text: "Change",
              components: customisations.map {|f| f['customisation_value']['name']}
            } || nil
          ].compact,
          media: product.images.map {|image|
            {
              type: :photo,
              src: PRODUCT_IMAGE_SIZES.map {|image_size|
                geometry = Paperclip::Geometry.parse(image.attachment.styles['product'].geometry)

                {
                  name: image_size,
                  width: image_size == :original ? image.attachment_width : geometry.width,
                  height: image_size == :original ? image.attachment_height : geometry.height,
                  url: image.attachment.url(image_size),
                }
              },
              sort_order: image.position,
              content_type: image.attachment_content_type,
              options: [
                image&.viewable&.option_value&.name
              ]
            }
          },
          default_selections: [
            product.master
          ]
        }
        respond_with produt_viewmodel.to_json
      end

      private
      def find_product_property(product, property_name)
        product.product_properties.find {|pp| pp.property.name == property_name}&.value
      end

    end
  end


end
