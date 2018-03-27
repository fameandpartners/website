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
MIN_INCH = 58
MAX_INCH = 76

PRODUCT_IMAGE_SIZES = [:original, :product]


FAKE_COMPONENTS = [
  {code: 'BC1', name: 'Strapless'},
  {code: 'BC2', name: 'Strappy'},
  {code: 'BC3', name: 'Classic'},
  {code: 'BC4', name: 'Relaxex'},
  {code: 'BC5', name: 'One-Shoulder'},
  {code: 'BC6', name: 'Tri-Cup'},
  {code: 'BC7', name: 'Draped'},
  {code: 'T76', name: 'Subtle Sweetheart Neckline'},
  {code: 'T2', name: 'Curved Neckline'},
  {code: 'T3', name: 'Sweetheart Neckline'},
  {code: 'T4', name: 'Straight Neckline'},
  {code: 'T1', name: 'Strapless With Straight Neckline'},
  {code: 'T11', name: 'V-Back Neckline'},
  {code: 'T15', name: 'Plunging V-Back Neckline'},
  {code: 'T2', name: 'Curved Back Neckline'},
  {code: 'WB1', name: 'Standard'},
  {code: 'WB2', name: 'Wide'},
  {code: 'T51', name: 'Off-Sholder Sleeves'},
  {code: 'T31', name: 'Off-Shoulder Panel'},
  {code: 'T52', name: 'Wide Arm Ties'},
  {code: 'T22', name: 'Fixed Spaghetti Straight Straps'},
  {code: 'T26', name: 'Fixed Spaghetti Cross Back Straps'},
  {code: 'T71', name: 'Narrow Adjustable Straight Straps'},
  {code: 'T85', name: 'Narrow Adjustable Cross Back Straps'},
  {code: 'T30', name: 'Wide Fixed Straight Straps'},
  {code: 'T25', name: 'Wide Fixed Cross Back Straps'},
  {code: 'T33', name: 'Wide Tie Straps'},
  {code: 'T60', name: 'Side Cut-Outs'},
  {code: 'T58', name: 'Bow'},
  {code: 'A5', name: 'Cape'},
  {code: 'T52', name: 'Wide Arm Ties'},
]

FAKE_GROUPS = [
  {
    title: "Silhouette",
    sectionGroups: [
      {
        title: "Style",
        sections: [
          {
            title: "Select your style",
            components: [
              'BC1', 'BC2', 'BC3', 'BC4', 'BC5', 'BC6', 'BC7'
            ]
          }
        ]
      },
      {
        title: "Length",
        sections: [
          {
            title: "Select your length",
            components: [
              'extra-mini', 'mini', 'midi', 'maxi', 'knee'
            ]
          }
        ]
      }
    ]
  },
  {
    title: "Customization",
    sectionGroups: [
      {
        title: "Front & Back",
        sections: [
          {
            title: "Select your front",
            components: ["T76", "T2", "T3", "T4"]
          },
          {
            title: "Select your back",
            components: ["T1", "T11", "T15", "T2"]
          },
          {
            title: "Select your waistband",
            components: ["WB1", "WB2"]
          }
        ]
      },
      {
        title: "Straps & Sleeves",
        sections: [
          {
            title: "Select your straps & sleeves",
            components: [
              "T22", "T26", "T71", "T30", "T30", "T33", "T34", "T68", "T51", "T31", "T52", "T25", "T85", "T71"
            ]
          }
        ]
      },
      {
        title: "Extras",
        sections: [
          {
            title: "Select your extras",
            components: [
              "T60", "T58", "A5", "T52"
            ]
          }
        ]
      }
    ]
  }
]


module Api
  module V1
    class ProductsController < ApplicationController
      respond_to :json

      def show
        product = Spree::Product.find(params[:id])

        colors = product.product_color_values.active
        fabrics = product.fabrics
        sizes = product.option_types.find_by_name('dress-size').option_values
        customisations = JSON.parse!(product.customizations)


        produt_viewmodel = {
          id: product.id,
          masterVariantId: product.master.id,
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

          returnDescription: "Shipping is free on your customized item. <a href=" ">Learn more</a>",
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
            minHeightInch: MIN_INCH,
            maxHeightInch: MAX_INCH,
            sizeChart: product.size_chart,
          },
          components: [
            colors.map {|c|
              {
                id: c.option_value.id,
                code: c.option_value.name,
                name: c.option_value.presentation,
                type: :color,
                sortOrder: c.option_value.position,
                hex: c.option_value.value,
                img: color_image(c.option_value.image_file_name),
                incompatibilities: c.custom ? ['express_making'] : [],
                isRecommended: !c.custom,
                price: c.custom ? (LineItemPersonalization::DEFAULT_CUSTOM_COLOR_PRICE * 100).to_i : 0,
              }
            },

            fabrics.map {|c|
              {
                id: c.option_value.id,
                code: c.option_value.name,
                name: c.option_value.presentation,
                type: :fabric,
                sortOrder: c.option_value.position,
                hex: c.option_value.value,
                img: c.option_value.image_file_name,
                incompatibilities: c.custom ? ['express_making'] : [],
                isRecommended: !c.custom,
              }
            },

            sizes.map {|c|
              {
                id: c.id,
                code: c.name,
                name: c.presentation,
                name_us: c.name.split("/")[0],
                name_au: c.name.split("/")[1],
                type: :size,
                sortOrder: c.position,
                # price: c.custom ? (LineItemPersonalization::DEFAULT_CUSTOM_SIZE_PRICE*100).to_i : 0,
                incompatibilities: [],
              }
            },

            customisations.map {|c|
              {
                id: c['customisation_value']['id'],
                code: c['customisation_value']['name'],
                name: c['customisation_value']['presentation'],
                type: :customisation,
                sortOrder: c['customisation_value']['position'],
                img: customization_image(c['customisation_value']),
                incompatibilities: ['express_making'],
                price: (BigDecimal.new(c['customisation_value']['price']) * 100).to_i,
              }
            },

            product.id == 1009 ? FAKE_COMPONENTS : nil,

            [
              {
                code: 'express_making',
                name: "Express Making",
                delivery_time: '2 weeks',
                type: :making,
                sortOrder: 1,
              },

              {
                code: 'free_returns',
                name: "Free returns",
                return_policy: "Returns blah blah",
                type: :returns,
                sortOrder: 1,
              }
            ]
          ].flatten,
          groups: [
            sizes.length > 0 && {
              title: 'Size',
              changeButtonText: "Select",
              type: :size,
              sectionGroups: [
                {
                  title: "Size",
                  sections: [
                    {
                      title: "Select your height and size",
                      selectionType: "requiredOne",
                      options: sizes.map(&:name)
                    }]
                }]
            } || nil,

            colors.length > 0 && {
              title: 'Color',
              changeButtonText: "Change",
              sectionGroups: [
                {
                  title: "Color",
                  sections: [
                    {
                      title: "Select your color",
                      options: colors.map {|c| c.option_value.name},
                      selectionType: "requiredOne",
                    }]
                }
              ]
            } || nil,

            fabrics.length > 0 && {
              title: 'Fabric',
              changeButtonText: "Change",
              sectionGroups: [
                {
                  title: "Color & Fabric",
                  sections: [
                    {
                      title: "Select your color & fabric",
                      options: fabrics.map {|f| f.option_value.name},
                      selectionType: "requiredOne",

                    }]
                }
              ]
            } || nil,

            customisations.length > 0 && {
              title: 'Customize',
              changeButtonText: "Change",
              selectionType: customisations.length === 3 ? "optionalOne" : 'optionalMultiple',
              sectionGroups: [
                {
                  title: "Customize",
                  section: [
                    {
                      title: "Select your customizations",
                      options: customisations.map {|f| f['customisation_value']['name']},
                    }
                  ]
                }
              ]
            } || nil,

            product.id == 1009 ? FAKE_GROUPS : nil,
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
              sortOrder: image.position,
              contentType: image.attachment_content_type,
              options: [
                image&.viewable&.option_value&.name
              ]
            }
          },

          layerCads: product.layer_cads.map {|lc|
            {
              url: lc.base_image_name ? lc.base_image.url : lc.layer_image.url,
              width: lc.width,
              height: lc.height,
              sortOrder: lc.position,
              type: lc.base_image_name ? :base : :layer,
              components: lc.customizations_enabled_for.map.with_index {|active, index|
                active ? customisations[index]['customisation_value']['name'] : nil
              }.compact
            }
          },


          #defaultSelections: [
          #  product.master
          #]
        }
        respond_with produt_viewmodel.to_json
      end

      private
      def find_product_property(product, property_name)
        product.product_properties.find {|pp| pp.property.name == property_name}&.value
      end


      def color_image(image_file_name)
        return nil unless image_file_name

        "#{configatron.asset_host}/assets/product-color-images/#{image_file_name}"
      end

      def customization_image(customization)
        return nil unless customization['image_file_name']

        "#{configatron.asset_host}/system/images/#{customization['id']}/original/#{customization['image_file_name']}"
      end

    end
  end


end
