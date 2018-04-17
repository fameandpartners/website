MIN_CM = 147
MAX_CM = 193
MIN_INCH = 58
MAX_INCH = 76

# {
#   code: '',
#   title: '',
#   incompatibleWith: [],
#   price: 0,
#   meta: { image: { url: '' }},
# },

PRODUCT_IMAGE_SIZES = [:original, :product]

CARE_DESCRIPTION = "<p>Professional dry-clean only. <br />See label for further details.</p>"

FAKE_PRODUCT_ID = 1619

FAKE_COMPONENTS = [
  #  Silhouette
  #  Style
  {code: 'BC1', title: 'Strapless', incompatibleWith: ['T2', 'T31', 'T76'], price: 100, meta: { image: { url: 'https://www.fameandpartners.com/images/bridesmaids_builder/top_strapless_200.jpg' } }},
  {code: 'BC2', title: 'Strappy', incompatibleWith: [], price: 100, meta: { image: { url: 'https://www.fameandpartners.com/images/bridesmaids_builder/top_strappy_200.jpg' } }},
  {code: 'BC3', title: 'Classic', incompatibleWith: [], price: 100, meta: { image: { url: nil } }},
  {code: 'BC4', title: 'Relaxed', incompatibleWith: [], price: 100, meta: { image: { url: nil } }},
  {code: 'BC5', title: 'One-Shoulder', incompatibleWith: [], price: 100, meta: { image: { url: nil } }},
  {code: 'BC6', title: 'Tri-Cup', incompatibleWith: [], price: 100, meta: { image: { url: nil } }},
  {code: 'BC7', title: 'Draped', incompatibleWith: [], price: 100, meta: { image: { url: nil } }},

  # Length
  {code: 'extra-mini', title: 'Extra Mini', incompatibleWith: [], price: 100, meta: { image: { url: 'https://www.fameandpartners.com/images/bridesmaids_builder/length_column_micro_148.jpg' } }},
  {code: 'mini', title: 'Mini', incompatibleWith: [], price: 100, meta: { image: { url: 'https://www.fameandpartners.com/images/bridesmaids_builder/length_column_mini_148.jpg' } }},
  {code: 'knee', title: 'Knee', incompatibleWith: [], price: 100, meta: { image: { url: 'https://www.fameandpartners.com/images/bridesmaids_builder/length_column_knee_148.jpg' } }},
  {code: 'midi', title: 'Midi', incompatibleWith: [], price: 100, meta: { image: { url: 'https://www.fameandpartners.com/images/bridesmaids_builder/length_column_midi_148.jpg' } }},
  {code: 'ankle', title: 'Ankle', incompatibleWith: [], price: 100, meta: { image: { url: 'https://www.fameandpartners.com/images/bridesmaids_builder/length_column_ankle_148.jpg' } }},
  {code: 'maxi', title: 'Maxi', incompatibleWith: [], price: 100, meta: { image: { url: 'https://www.fameandpartners.com/images/bridesmaids_builder/length_column_maxi_148.jpg' } }},

  # Front
  {code: 'T76', title: 'Subtle Sweetheart Neckline', incompatibleWith: ['BC1'], price: 100, meta: { image: { url: nil } }},
  {code: 'T2', title: 'Curved Neckline', incompatibleWith: ['BC1', 'T51'], price: 100, meta: { image: { url: nil } }},
  {code: 'T3', title: 'Sweetheart Neckline', incompatibleWith: [], price: 100, meta: { image: { url: nil } }},
  {code: 'T4', title: 'Straight Neckline', incompatibleWith: ['T75'], price: 100, meta: { image: { url: nil } }},

  # Back
  {code: 'T1', title: 'Strapless With Straight Neckline', incompatibleWith: [], price: 100, meta: { image: { url: nil } }},
  {code: 'T11', title: 'V-Back Neckline', incompatibleWith: [], price: 100, meta: { image: { url: nil } }},
  {code: 'T15', title: 'Plunging V-Back Neckline', incompatibleWith: [], price: 100, meta: { image: { url: nil } }},
  {code: 'T2', title: 'Curved Back Neckline', incompatibleWith: [], price: 100, meta: { image: { url: nil } }},

  # Bodice
  {
    code: 'T7',
    title: 'Change to Halter Neckline with Back Ties',
    incompatibleWith: [],
    price: 10,
    meta: { image: { url: '' }},
  },

  # Waistband
  {code: 'WB1', title: 'Standard', incompatibleWith: [], price: 100, meta: { image: { url: nil } }},
  {code: 'WB2', title: 'Wide', incompatibleWith: [], price: 100, meta: { image: { url: nil } }},

  # Straps and Sleeves
  {code: 'T51', title: 'Off-Sholder Sleeves', incompatibleWith: ['T2'], price: 100, meta: { image: { url: nil } }},
  {code: 'T31', title: 'Off-Shoulder Panel', incompatibleWith: ['BC1'], price: 100, meta: { image: { url: nil } }},
  {code: 'T52', title: 'Wide Arm Ties', incompatibleWith: ['T71'], price: 100, meta: { image: { url: nil } }},
  {code: 'T22', title: 'Fixed Spaghetti Straight Straps', incompatibleWith: [], price: 100, meta: { image: { url: nil } }},
  {code: 'T26', title: 'Fixed Spaghetti Cross Back Straps', incompatibleWith: [], price: 100, meta: { image: { url: nil } }},
  {code: 'T71', title: 'Narrow Adjustable Straight Straps', incompatibleWith: ['T52'], price: 100, meta: { image: { url: nil } }},
  {code: 'T85', title: 'Narrow Adjustable Cross Back Straps', incompatibleWith: [], price: 100, meta: { image: { url: nil } }},
  {code: 'T30', title: 'Wide Fixed Straight Straps', incompatibleWith: [], price: 100, meta: { image: { url: nil } }},
  {code: 'T25', title: 'Wide Fixed Cross Back Straps', incompatibleWith: ['T4'], price: 100, meta: { image: { url: nil } }},
  {code: 'T33', title: 'Wide Tie Straps', incompatibleWith: [], price: 100, meta: { image: { url: nil } }},

  # Extras
  {code: 'T60', title: 'Side Cut-Outs', incompatibleWith: [], price: 100, meta: { image: { url: nil } }},
  {code: 'T58', title: 'Bow', incompatibleWith: [], price: 100, meta: { image: { url: nil } }},
  {code: 'A5', title: 'Cape', incompatibleWith: [], price: 100, meta: { image: { url: nil } }},
]

FAKE_GROUPS = [
  {
    id: 1,
    title: "Silhouette",
    slug: 'silhouette',
    sectionGroups: [
      {
        id: 1,
        title: "Style",
        slug: 'style',
        previewType: :render,
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
        id: 2,
        title: "Length",
        slug: 'length',
        previewType: :render,
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
    id: 2,
    title: "Customization",
    slug: 'customization',
    sectionGroups: [
      {
        id: 3,
        title: "Front & Back",
        slug: 'front-and-back',
        previewType: :render,
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
        id: 4,
        title: "Straps & Sleeves",
        slug: 'straps-and-sleeves',
        previewType: :render,
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
        id: 5,
        title: "Extras",
        slug: 'extras',
        previewType: :render,
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
        fabrics = product.fabric_products
        sizes = product.option_types.find_by_name('dress-size').option_values
        customizations = JSON.parse!(product.customizations)


        product_viewmodel = {
          id: product.id,
          cartId: product.master.id,
          returnDescription: 'Shipping is free on your customized item. <a href="/faqs#collapse-returns-policy" target="_blank">Learn more</a>',
          deliveryTimeDescription: "Estimated delivery 6 weeks.",

          curationMeta: {
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
            fabrics.empty? ? colors.map.with_index {|c, index|
              {
                sectionId: :color,
                cartId: c.option_value.id,
                code: c.option_value.name,
                isDefault: index == 0,
                isRecommended: !c.custom,
                title: c.option_value.presentation,
                price: c.custom ? (LineItemPersonalization::DEFAULT_CUSTOM_COLOR_PRICE * 100).to_i : 0,
                "isProductCode": true,
                type: :color,
                "meta": {
                  sortOrder: c.option_value.position,
                  hex: c.option_value.value&.include?('#') ? c.option_value.value : nil,
                  image: {
                    url: c.option_value.value&.include?('#') ? color_image(c.option_value.image_file_name) : color_image(c.option_value.value),
                    width: 0,
                    height: 0,
                  },

                  careDescription: CARE_DESCRIPTION,
                  fabricDescription: find_product_property(product, 'fabric'),
                },
                incompatibleWith: c.custom ? ['express_making'] : [],
                compatibleWith: [],
              }
            } : [],

            fabrics.map {|f|
              {
                sectionId: :fabric,
                cartId: f.fabric.id,
                code: f.fabric.name,
                isDefault: false,
                isRecommended: f.recommended,
                title: f.fabric.presentation,
                price: f.recommended ? 0 : (f.fabric.price_in(current_site_version.currency) * 100).to_i,
                "isProductCode": true,
                type: :fabric,
                meta: {
                  sortOrder: -1, #TODO
                  # hex: c.option_value.value,
                  
                  image: {
                    url: f.fabric.image_url,
                    width: 0,
                    height: 0,
                  },

                  careDescription: CARE_DESCRIPTION,
                  fabricDescription: f.description,
                },
                img: f.fabric.image_url,
                incompatibleWith: f.recommended ? [] : ['express_making'],
                compatibleWith: [],
              }
            },

            sizes.map {|c|
              {
                sectionId: :size,
                cartId: c.id,
                code: c.name,
                isDefault: false,
                title: c.presentation,
                price: 0,
                isProductCode: false,
                type: :size,
                meta: {
                  sortOrder: c.position,
                  sizeUs: c.name.split("/")[0],
                  sizeAu: c.name.split("/")[1],

                  careDescription: CARE_DESCRIPTION,
                  fabricDescription: find_product_property(product, 'fabric'),
                },
                compatibleWith: [],
                incompatibleWith: [],
              }
            },

            product.id == FAKE_PRODUCT_ID ? [] : customizations.map {|c|
              {
                sectionId: :legacyCustomization,
                cartId: c['customisation_value']['id'],
                code: c['customisation_value']['name'],
                isDefault: false,
                title: c['customisation_value']['presentation'],
                price: (BigDecimal.new(c['customisation_value']['price']) * 100).to_i,
                isProductCode: true,
                type: :legacyCustomization,
                meta: {
                  sortOrder: c['customisation_value']['position'],
                  image: {
                    url: customization_image(c['customisation_value']),
                    width: -1,
                    height: -1
                  }
                },
                compatibleWith: [],
                incompatibleWith: [],
              }
            },

            product.id == FAKE_PRODUCT_ID ? FAKE_COMPONENTS : nil,


            product.making_options
              .reject { |making| making.slow_making? }
              .map { |making|
              {
                sectionId: :making,
                cartId: making.id,
                code: making.option_type,
                isDefault: false,
                title: making.name,
                price: (making.price*100).to_i,
                isProductCode: false,
                type: :making,
                meta: {
                  sortOrder: making.super_fast_making? ? 1 : making.fast_making? ? 2 : 3,
                  deliveryTimeDescription: making.description,
                  deliveryTimeRange: making.display_delivery_period
                },
                compatibleWith: [],
                incompatibleWith: [],
              }
            },

            [
              {
                sectionId: :todo,
                cartId: 0,
                code: 'free_returns',
                isDefault: false,
                title: "Free returns",
                price: 0,
                isProductCode: false,
                type: :return,
                meta: {
                  sortOrder: 1,
                  returnDescription: 'Shipping and returns are free. <a href="/faqs#collapse-returns-policy" target="_blank">Learn more</a>'
                },
                compatibleWith: [],
                incompatibleWith: [],
              }
            ]
          ].flatten.compact,
          groups: [
            colors.length > 0  && fabrics.empty? && {
              title: 'Color',
              changeButtonText: "Change",
              slug: 'color',
              sectionGroups: [
                {
                  title: "Color",
                  slug: 'color',
                  previewType: product.id == FAKE_PRODUCT_ID ? :render : :image,
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
              slug: 'fabric',
              sectionGroups: [
                {
                  title: "Color & Fabric",
                  slug: 'fabric',
                  previewType: product.id == FAKE_PRODUCT_ID ? :render : :image,
                  sections: [
                    {
                      title: "Select your color & fabric",
                      options: fabrics.map {|f| f.fabric.name},
                      selectionType: "requiredOne",

                    }]
                }
              ]
            } || nil,

            product.id != FAKE_PRODUCT_ID && customizations.length > 0 && {
              title: 'Customize',
              changeButtonText: "Change",
              slug: 'customize',
              id: 122,
              sectionGroups: [
                {
                  title: "Customize",
                  slug: 'customize',
                  previewType: :cad,
                  sections: [
                    {
                      title: "Select your customizations",
                      options: customizations.map {|f| f['customisation_value']['name']},
                      selectionType: customizations.length === 3 ? "optionalOne" : 'optionalMultiple',
                    }
                  ]
                }
              ]
            } || nil,

            product.id == FAKE_PRODUCT_ID ? FAKE_GROUPS : nil,

            sizes.length > 0 && {
              title: 'Size',
              changeButtonText: "Select",
              sortOrder: 9,
              slug: 'size',
              sectionGroups: [
                {
                  title: "Size",
                  slug: 'size',
                  previewType: product.id == FAKE_PRODUCT_ID ? :render : :image,
                  sections: [
                    {
                      title: "Select your height and size",
                      selectionType: "requiredOne",
                      options: sizes.map(&:name)
                    }]
                }]
            } || nil,
          ].flatten.compact,

          media: product.images
            .reject { |i| i.attachment_file_name.downcase.include?('crop') }
            .map {|image|
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

          layerCads: [
            product.layer_cads.map {|lc|
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
            },
            
            customizations.map {|c|
              {
                url: customization_image(c['customisation_value']),
                width: -1,
                height: -1,
                sortOrder: c['customisation_value']['position'],
                type: :layer,
                components: [c['customisation_value']['name']]
              }
            }
          ].flatten.compact,
        }
        respond_with product_viewmodel.to_json
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
