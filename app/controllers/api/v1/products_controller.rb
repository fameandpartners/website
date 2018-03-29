MIN_CM = 147
MAX_CM = 193
MIN_INCH = 58
MAX_INCH = 76

PRODUCT_IMAGE_SIZES = [:original, :product]

CARE_DESCRIPTION = "<p>Professional dry-clean only. <br />See label for further details.</p>"

FAKE_COMPONENTS = [
  {code: 'BC1', name: 'Strapless', incompatibilities: [], price: 100},
  {code: 'BC2', name: 'Strappy', incompatibilities: [], price: 100},
  {code: 'BC3', name: 'Classic', incompatibilities: [], price: 100},
  {code: 'BC4', name: 'Relaxed', incompatibilities: [], price: 100},
  {code: 'BC5', name: 'One-Shoulder', incompatibilities: [], price: 100},
  {code: 'BC6', name: 'Tri-Cup', incompatibilities: [], price: 100},
  {code: 'BC7', name: 'Draped', incompatibilities: [], price: 100},
  {code: 'T76', name: 'Subtle Sweetheart Neckline', incompatibilities: [], price: 100},
  {code: 'T2', name: 'Curved Neckline', incompatibilities: [], price: 100},
  {code: 'T3', name: 'Sweetheart Neckline', incompatibilities: [], price: 100},
  {code: 'T4', name: 'Straight Neckline', incompatibilities: [], price: 100},
  {code: 'T1', name: 'Strapless With Straight Neckline', incompatibilities: [], price: 100},
  {code: 'T11', name: 'V-Back Neckline', incompatibilities: [], price: 100},
  {code: 'T15', name: 'Plunging V-Back Neckline', incompatibilities: [], price: 100},
  {code: 'T2', name: 'Curved Back Neckline', incompatibilities: [], price: 100},
  {code: 'WB1', name: 'Standard', incompatibilities: [], price: 100},
  {code: 'WB2', name: 'Wide', incompatibilities: [], price: 100},
  {code: 'T51', name: 'Off-Sholder Sleeves', incompatibilities: [], price: 100},
  {code: 'T31', name: 'Off-Shoulder Panel', incompatibilities: [], price: 100},
  {code: 'T52', name: 'Wide Arm Ties', incompatibilities: [], price: 100},
  {code: 'T22', name: 'Fixed Spaghetti Straight Straps', incompatibilities: [], price: 100},
  {code: 'T26', name: 'Fixed Spaghetti Cross Back Straps', incompatibilities: [], price: 100},
  {code: 'T71', name: 'Narrow Adjustable Straight Straps', incompatibilities: [], price: 100},
  {code: 'T85', name: 'Narrow Adjustable Cross Back Straps', incompatibilities: [], price: 100},
  {code: 'T30', name: 'Wide Fixed Straight Straps', incompatibilities: [], price: 100},
  {code: 'T25', name: 'Wide Fixed Cross Back Straps', incompatibilities: [], price: 100},
  {code: 'T33', name: 'Wide Tie Straps', incompatibilities: [], price: 100},
  {code: 'T60', name: 'Side Cut-Outs', incompatibilities: [], price: 100},
  {code: 'T58', name: 'Bow', incompatibilities: [], price: 100},
  {code: 'A5', name: 'Cape', incompatibilities: [], price: 100},
  {code: 'extra-mini', name: 'Extra Mini', incompatibilities: [], price: 100},
  {code: 'mini', name: 'Mini', incompatibilities: [], price: 100},
  {code: 'midi', name: 'Midi', incompatibilities: [], price: 100},
  {code: 'maxi', name: 'Maxi', incompatibilities: [], price: 100},
  {code: 'knee', name: 'Knee', incompatibilities: [], price: 100},
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
            options: [
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
            options: [
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
            options: ["T76", "T2", "T3", "T4"]
          },
          {
            title: "Select your back",
            options: ["T1", "T11", "T15"]
          },
          {
            title: "Select your waistband",
            options: ["WB1", "WB2"]
          }
        ]
      },
      {
        title: "Straps & Sleeves",
        sections: [
          {
            title: "Select your straps & sleeves",
            options: [
              "T22", "T26", "T71", "T30", "T33", "T34", "T68", "T51", "T31", "T52", "T25", "T85"
            ]
          }
        ]
      },
      {
        title: "Extras",
        sections: [
          {
            title: "Select your extras",
            options: [
              "T60", "T58", "A5", "T52"
            ],
            selectionType: "optionalMultiple"
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
        product = Spree::Product.active.find(params[:id])

        colors = product.product_color_values.active
        fabrics = product.fabrics
        sizes = product.option_types.find_by_name('dress-size').option_values
        customisations = JSON.parse!(product.customizations)


        produt_viewmodel = {
          id: product.id,
          cartId: product.master.id,
          previewType: product.id == 1009 ? :render : :illustration,

          returnDescription: "Shipping is free on your customized item. <a href=" ">Learn more</a>",
          deliveryTimeDescription: "Estimated delivery 6 weeks.",

          meta: {
            name: product.name,
            description: product.description,
            keywords: product.meta_keywords,
            styleDescription: find_product_property(product, 'style_notes'),
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
                cartId: c.option_value.id,
                code: c.option_value.name,
                isDefault: false,
                isRecommended: !c.custom,
                sortOrder: c.option_value.position,
                title: c.option_value.presentation,
                price: c.custom ? (LineItemPersonalization::DEFAULT_CUSTOM_COLOR_PRICE * 100).to_i : 0,
                "isProductCode": true,
                type: :color,
                "meta": {
                  hex: c.option_value.value,
                  image: {
                    src: color_image(c.option_value.image_file_name),
                    width: 0,
                    height: 0,
                  },

                  careDescription: CARE_DESCRIPTION,
                  fabricDescription: find_product_property(product, 'fabric'),
                },
                incompatibleWith: c.custom ? ['express_making'] : [],
                compatibleWith: [],
              }
            },

            fabrics.map {|c|
              {
                cartId: c.id,
                code: c.name,
                isDefault: false,
                isRecommended: !c.price_in(current_site_version.currency)  == 0,
                sortOrder: -1, #TODO
                title: c.presentation,
                price: c.price_in(current_site_version.currency),
                "isProductCode": true,
                type: :fabric,
                meta: {
                  # hex: c.option_value.value,
                  image: {
                    src: c.image_url,
                    width: 0,
                    height: 0,
                  },

                  care: CARE_DESCRIPTION,
                  fabric: fabric.description || find_product_property(product, 'fabric'),
                },
                img: c.image_url,
                incompatibleWith: c.price_in(current_site_version.currency)  > 0 ? ['express_making'] : [],
                compatibleWith: [],
              }
            },

            sizes.map {|c|
              {
                cartId: c.id,
                code: c.name,
                isDefault: false,
                sortOrder: c.position,
                title: c.presentation,
                price: 0,
                isProductCode: false,
                type: :size,
                meta: {
                  sizeUs: c.name.split("/")[0],
                  sizeAu: c.name.split("/")[1],
                },
                compatibleWith: [],
                incompatibleWith: [],
              }
            },

            customisations.map {|c|
              {
                cartId: c['customisation_value']['id'],
                code: c['customisation_value']['name'],
                isDefault: false,
                sortOrder: c['customisation_value']['position'],
                title: c['customisation_value']['presentation'],
                price: (BigDecimal.new(c['customisation_value']['price']) * 100).to_i,
                isProductCode: true,
                type: :customisation,
                meta: {
                  image: {
                    src: customization_image(c['customisation_value']),
                    width: -1,
                    height: -1
                  }
                },
                compatibleWith: [],
                incompatibleWith: ['express_making'],
              }
            },

            product.id == 1623 ? FAKE_COMPONENTS : nil,

            [
              {
                cartId: :todo,
                code: 'express_making',
                isDefault: false,
                sortOrder: 1,
                title: "Express Making",
                price: 1800,
                isProductCode: false,
                type: :making,
                meta: {
                  deliveryTimeDescription: '2 weeks',
                },
                compatibleWith: [],
                incompatibleWith: [],
              },
              {
                cartId: :todo,
                code: 'free_returns',
                isDefault: false,
                sortOrder: 1,
                title: "Free returns",
                price: 0,
                isProductCode: :false,
                type: :return,
                meta: {
                  returnPolicy: "Returns blah blah"
                },
                compatibleWith: [],
                incompatibleWith: [],
              }
            ]
          ].flatten.compact,
          groups: [
            sizes.length > 0 && {
              title: 'Size',
              sortOrder: 1,
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
              type: :color,
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
              type: :fabric,
              sectionGroups: [
                {
                  title: "Color & Fabric",
                  sections: [
                    {
                      title: "Select your color & fabric",
                      options: fabrics.map {|f| f.name},
                      selectionType: "requiredOne",

                    }]
                }
              ]
            } || nil,

            customisations.length > 0 && {
              title: 'Customize',
              changeButtonText: "Change",
              type: :customisation,

              sectionGroups: [
                {
                  title: "Customize",
                  sections: [
                    {
                      title: "Select your customizations",
                      options: customisations.map {|f| f['customisation_value']['name']},
                      selectionType: customisations.length === 3 ? "optionalOne" : 'optionalMultiple',
                    }
                  ]
                }
              ]
            } || nil,

            product.id == 1623 ? FAKE_GROUPS : nil,
          ].flatten.compact,
          media: product.images.map {|image|
            {
              type: :photo,
              fitDescription: find_product_property(product, 'fit'),
              sizeDescription: find_product_property(product, 'size'),
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
                image&.viewable_type == "FabricsProduct" ? image&.viewable&.fabric&.name  : image&.viewable&.option_value&.name

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
