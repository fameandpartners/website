MIN_CM = 147
MAX_CM = 193
MIN_INCH = 58
MAX_INCH = 76

PRODUCT_IMAGE_SIZES = [[:xxxlarge, :webp_xxxlarge], [:xxlarge, :webp_xxlarge], [:xlarge, :webp_xlarge], [:large, :webp_large], [:medium, :webp_medium], [:small, :webp_small], [:xsmall, :webp_xsmall], [:xxsmall, :webp_xxsmall]]
LIST_PRODUCT_IMAGE_SIZES = [[:xlarge, :webp_xlarge], [:large, :webp_large], [:medium, :webp_medium], [:small, :webp_small], [:xsmall, :webp_xsmall], [:xxsmall, :webp_xxsmall]]

CARE_DESCRIPTION = "<p>Professional dry-clean only. <br />See label for further details.</p>"

module Api
  module V1
    class ProductsController < Api::ApiBaseController
      include PathBuildersHelper

      respond_to :json
      caches_action :show, expires_in: configatron.cache.expire.long, :cache_path => Proc.new {|c| c.request.url }
      caches_action :index, expires_in: configatron.cache.expire.long, :cache_path => Proc.new {|c| c.request.url }
      caches_action :search, expires_in: configatron.cache.expire.long, :cache_path => Proc.new {|c| c.request.url }


      def import_summary
        spree_products = Spree::Product
          .not_deleted
          .includes(:master)
          .reject(&:is_new_product?)

        respond_with ({
          products: spree_products.map{|p| { id: p.id, sku: p.sku, name: p.name, updated_at: p.updated_at, created_at: p.created_at  } }
        })
      end

      def index
        pids = params[:pids] || []

        skus = pids.collect { |pid| pid.split("~").first }

        spree_products = Spree::Product
          .not_deleted
          .includes(:master)
          .where(spree_variants: {sku: skus})

        products = pids.collect do |pid|
          components = pid.split("~")
          sku = components.shift
          spree_product = spree_products
            .sort_by(&:created_at) # make sure we select the latest product
            .reverse
            .find { |p| p.master.sku == sku }

          next unless spree_product

          all_customizations = JSON.parse!(spree_product.customizations)

          pcv = spree_product.product_color_values.find { |pvc| components.include?(pvc.option_value.name) }
          fabric_product = spree_product.fabric_products.find { |fp| components.include?(fp.fabric.name) }
          customizations = all_customizations.select { |c|  components.include?(c["customisation_value"]["name"]) }.map {|c| ["customisation_value"]["name"]}

          price = spree_product.price_in(current_site_version.currency).amount +
            (fabric_product ? fabric_product.price_in(current_site_version.currency) : 0) +
            (pcv&.custom ? LineItemPersonalization::DEFAULT_CUSTOM_COLOR_PRICE: 0)

          if spree_product.discount
              sale_price = spree_product.price_in(current_site_version.currency).apply(spree_product.discount).amount +
              (fabric_product ? fabric_product.price_in(current_site_version.currency) : 0) +
              (pcv&.custom ? LineItemPersonalization::DEFAULT_CUSTOM_COLOR_PRICE: 0)
          end

          {
            pid: pid,
            name: spree_product.name,
            url: collection_product_path(spree_product, color: fabric_product&.fabric&.name || pcv&.option_value.name),
            media: product.images_for_customisation(pcv.option_value.name, fabric_product.fabric.name, customizations, true)
              .sort_by(&:position)
              .take(2)
              .collect do |image|
              {
                type: :photo,
                src: LIST_PRODUCT_IMAGE_SIZES.map {|sizes|
                  image_size = sizes[0]
                  webp_image_size = sizes[1]

                  geometry = Paperclip::Geometry.parse(image.attachment.styles[image_size].geometry)
                  width = [geometry.width.round, image.attachment_width].min
                  height = (image.attachment_height.to_f / image.attachment_width.to_f * width).round
      
                  {
                    name: image_size,
                    width: width,
                    height: height,
                    url: image.attachment.url(image_size),
                    urlWebp: image.attachment.url(webp_image_size),
                  }
                }.uniq {|i| i[:width] },
                sortOrder: image.position
              }
            end,
            price: sale_price ? (sale_price*100).to_i : (price*100).to_i,
            strikeThroughPrice: sale_price ? (price*100).to_i : nil,
          }
        end
        .compact

        respond_with products
      end

      def search
        color_mapping = {
          "print": "",
          "white-ivory": '#f5f4f3',
          "nude-tan": '#E6D4C0',
          "pastel": '#CBF6EB',
          "metallic": '#ACA8A2',
          "grey": '#7e7e7f',
          "yellow": '#e9de0a',
          "orange": '#ea5d32',
          "pink": '#f458a6',
          "red": '#e01b1b',
          "green": '#10a522',
          "purple": '#48217f',
          "blue": '#0000ff',
          "black": '#050505',
        }
        image_mapping = {
          "print": 'https://d2ta5pga3sqz6i.cloudfront.net/assets/product-color-images/BlackAndWhiteGingham.jpg',

        }

        filter = Array.wrap(params[:facets])

        # there is am overlap between color group names & taxons, so we make color groups win
        color_group_names = Repositories::ProductColors.color_groups.map {|cg| cg[:name]}
        color_names = filter
          .select { |f| color_group_names.include?(f) }
        taxon_names = filter
          .reject { |f| color_group_names.include?(f) }
          .reject { |f| ['0-199', '200-299', '300-399', '400'].include?(f) }

        offset = params[:lastIndex].to_i  || 0
        page_size = params[:pageSize].to_i || 36

        price_min = nil;
        price_max = nil;

        if filter.include?('0-199')
          price_min = 0
        elsif filter.include?('200-299')
          price_min = 200
        elsif filter.include?('300-399')
          price_min = 300
        elsif filter.include?('400')
          price_min = 400
        end

        if filter.include?('400')
          price_max = nil
        elsif filter.include?('300-399')
          price_max = 399
        elsif filter.include?('200-299')
          price_max = 299
        elsif filter.include?('0-199')
          price_max = 199
        end


        query_params = {
          taxon_names: taxon_names,
          color_group_names: color_names,
          order: params[:sortField],
          price_min: price_min,
          price_max: price_max,
          currency: current_currency.downcase,
          query_string: params[:query],
          include_aggregation_taxons: true,
          boost_pids: Array.wrap(params[:boostPids]),
          boost_facets: Array.wrap(params[:boostFacets]),
          exclude_taxon_names: Array.wrap(params[:excludeFacets])
        }
        query = Search::ColorVariantsESQuery.build(query_params)
        result = Elasticsearch::Client.new(host: configatron.es_url).search(
          index: configatron.elasticsearch.indices.color_variants,
          body: query,
          size: page_size,
          from: offset,
        )

        #taxons are additive
        aggregation_taxons = Hash[*result["aggregations"]["taxons"]["buckets"].map(&:values).flatten]


        aggregation_colors_result = Elasticsearch::Client.new(host: configatron.es_url).search(
          index: configatron.elasticsearch.indices.color_variants,
          body: Search::ColorVariantsESQuery.build(query_params.merge(color_group_names: nil, include_aggregation_color_group_names: true)),
          size: 0,
          from: 0
        )
        aggregation_colors = Hash[*aggregation_colors_result["aggregations"]["color_group_names"]["buckets"].map(&:values).flatten]

        aggregation_prices_result = Elasticsearch::Client.new(host: configatron.es_url).search(
          index: configatron.elasticsearch.indices.color_variants,
          body: Search::ColorVariantsESQuery.build(query_params.merge(price_min: nil, price_max: nil, include_aggregation_prices: true)),
          size: 0,
          from: 0
        )
        aggregation_prices = Hash[*aggregation_prices_result["aggregations"]["prices"]["buckets"].map{|key, value| [key, value["doc_count"]]}.flatten]

        response = {
          results: result['hits']['hits'].map do |r|
            {
              _score: r['_score'],
              pid: r['_source']['product']['pid'],
              productId: r['_source']['product']['sku'],
              name: r['_source']['product']['name'],
              strikeThroughPrice: r['_source']['non_sale_prices'] ? {
                "en-AU": r['_source']['non_sale_prices']['aud'] * 100,
                "en-US": r['_source']['non_sale_prices']['usd'] * 100
              } : nil,
              price: {
                "en-AU": r['_source']['prices']['aud'] * 100,
                "en-US": r['_source']['prices']['usd'] * 100
              },
              url: r['_source']['product']['url'],
              images: r['_source']['media'],
              productVersionId: 0,
            }
          end,

          "facetConfigurations": {
            "search": [
              {
                "name": "Filter by",
                "hideHeader": false,
                "facetGroupIds": [
                  "color",
                  "style",
                  # "bodyshape",
                  "price"
                ]
              }
            ],
          },
          facetGroups: {
            "color": {
              groupId: "color",
              name: "Color",
              multiselect: true,
              facets: Repositories::ProductColors.color_groups.each_with_index.map do |group, i|
                {
                  "facetId": group[:name],
                  "title": group[:presentation],
                  "order": color_mapping.keys.find_index(group[:name].to_sym),
                  "docCount": aggregation_colors[group[:name]] || 0,
                  "facetMeta": {
                    "hex": color_mapping[group[:name].to_sym],
                    "image": image_mapping[group[:name].to_sym]
                  }
                }
              end.sort_by{ |f| f[:order] }.select { |f| f[:docCount] > 0 || filter.include?(f[:facetId]) }
            },

            "style": {
              groupId: "style",
              name: "Style",
              multiselect: true,
              facets: Spree::Taxon.filterable.sort_by(&:permalink).sort_by(&:position).each_with_index.map do |taxon, i|
                code = taxon.permalink.split("/").last

                {
                  "facetId": code,
                  "title": taxon.name,
                  "order": i,
                  "docCount": aggregation_taxons[code]  || 0,
                }
              end.select { |f| f[:docCount] > 0 || filter.include?(f[:facetId]) }
            },

            # bodyshape: {
            #   groupId: "bodyshape",
            #   name: "Bodyshape",
            #   multiselect: true,
            #   facets: ProductStyleProfile::BODY_SHAPES.sort.each_with_index.map do |shape, i|
            #     {
            #       "facetId": shape,
            #       "title": shape.humanize,
            #       "order": i,
            #       "docCount": aggregation_body_shapes[i] || 0,
            #     }
            #   end.select { |f| f[:docCount] > 0 || filter.include?(f[:facetId]) }
            # },

            price: {
              groupId: "price",
              name: "Price",
              multiselect: true,
              facets: [
                {
                  facetId: '0-199',
                  title: '$0 - $199',
                  order: 0,
                  "docCount": aggregation_prices['0-199'],
                },
                {
                  facetId: '200-299',
                  title: '$200 - $299',
                  order: 1,
                  "docCount": aggregation_prices['200-299'],
                },
                {
                  facetId: '300-399',
                  title: '$300 - $399',
                  order: 2,
                  "docCount": aggregation_prices['300-399'],
                },
                {
                  facetId: '400',
                  title: '$400+',
                  order: 3,
                  "docCount": aggregation_prices['400'],
                }
              ].select { |f| f[:docCount] > 0 || filter.include?(f[:facetId]) }
            }
          },
          sortOptions: [
            # {
            #   name: "Sorted by most relevant",
            #   sortField: "native",
            #   sortOrder: ""
            # },
            # {
            #   name: "Sorted by best sellers",
            #   sortField: "best_sellers",
            #   sortOrder: ""
            # },
            {
              name: "Sorted by newest",
              sortField: "newest",
              sortOrder: ""
            },
            {
              name: "Sorted by price high to low",
              sortField: "price_high",
              sortOrder: ""
            },
            {
              name: "Sorted by price low to high",
              sortField: "price_low",
              sortOrder: ""
            }
          ],
          lastIndex: page_size + offset,
          lastValue: nil,
          hasMore: result['hits']['hits'].count == page_size,
        }

        respond_with response.to_json
      end


      def show
        product_id = params[:id]

        variant = Spree::Variant.order('id DESC').find_by_sku(params[:id])
        product_id = variant.product_id if variant

        product = Spree::Product
          .not_deleted
          .includes(:product_properties)
          .find(product_id)

        colors = product.product_color_values
          .includes(:option_value)
          .active

        fabrics = product
          .fabric_products
          .includes(fabric: [:option_fabric_color_value, :option_value])
          .active

        sizes = product.option_types.find_by_name('dress-size').option_values
        customizations = JSON.parse!(product.customizations)

        product_fabric = product.property('fabric')
        product_fit = product.property('fit')
        product_size = product.property('size')

        images = product
          .images

        product_viewmodel = {
          productId: product.sku,
          urlProductId: product.id,
          cartId: product.master.id,
          returnDescription: 'Shipping is free on your customized item. <a href="/faqs#panel-delivery" target="_blank">Learn more</a>',
          # deliveryTimeDescription: slow_making_option.try(:display_delivery_period),

          curationMeta: {
            name: product.name,
            description: product.description,
            keywords: product.meta_keywords,
            styleDescription: product.property('style_notes'),
            permaLink: product.name.parameterize
          },
          isAvailable: product.is_active?,
          price: (product.price_in(current_site_version.currency).apply(product.discount).amount * 100).to_i,
          strikeThroughPrice: product.discount ? (product.price_in(current_site_version.currency).amount * 100).to_i : nil,
          prices: {
            'en-AU' => (product.price_in('AUD').amount * 100).to_i,
            'en-US' => (product.price_in('USD').amount * 100).to_i,
          },
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
            fabrics.empty? ? colors.map {|c| map_color(product, c, product_fabric) }  : fabrics.map { |f| map_fabric(product, f) },

            sizes.map {|s| map_size(s) },

            customizations.map {|c| map_customization(product, c) },

            product.making_options
              .map { |making| map_making(product, making) },

            [
              {
                cartId: 0,
                code: 'free_returns',
                title: "Free returns",
                componentTypeId: :Return,
                componentTypeCategory: :Return,
                price: 0,
                strikeThroughPrice: 0,
                isProductCode: false,
                isRecommended: false,
                type: :return,
                sortOrder: 1,
                meta: {
                  returnDescription: 'All orders ship free. <a href="/faqs#panel-delivery" target="_blank">Learn more</a>'
                },
                incompatibleWith: { allOptions: [] },
              }
            ]
          ].flatten.compact,

          groups: [
            colors.length > 0 && fabrics.empty? && {
              id: 120,
              title: 'Color',
              selectionTitle: 'Select your Color',
              changeButtonText: "Change",
              slug: 'color',
              sectionGroups: [
                {
                  title: 'Color',
                  slug: 'color',
                  previewType: :image,
                  sections: [
                    {
                      componentTypeId: :Color,
                      componentTypeCategory: :Color,
                      title: "Select your color",
                      options: colors.map {|c| { code: c.option_value.name, isDefault: false, parentOptionId: nil } },
                      selectionType: :RequiredOne,
                    }]
                }
              ]
            } || nil,

            fabrics.length > 0 && {
              id: 121,
              title: 'Fabric & Color',
              selectionTitle: "Select your Fabric & Color",
              changeButtonText: "Change",
              slug: 'fabric',
              sectionGroups: [
                {
                  title: "Fabric & Color",
                  slug: 'fabric',
                  previewType: :image,
                  sections: [
                    {
                      componentTypeId: :ColorAndFabric,
                      componentTypeCategory: :ColorAndFabric,
                      selectionType: :RequiredOne,
                      options: fabrics.map {|f| { code: f.fabric.name, isDefault: false, parentOptionId: nil } },
                    }]
                }
              ]
            } || nil,

            customizations.length > 0 && {
              id: 122,
              title: 'Customizations',
              selectionTitle: "Customize your dress",
              changeButtonText: "Change",
              slug: 'customize',
              sectionGroups: [
                {
                  title: "Customizations",
                  slug: 'customize',
                  previewType: :cad,
                  sections: [
                    {
                      componentTypeId: :Customization,
                      componentTypeCategory: :Customization,
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
              selectionTitle: "Tell us your height and size",
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
        options = image.viewable.pid&.split('~') || []
        options.shift # remove sku

        {
          type: :photo,
          fitDescription: fixup_fit(product_fit),
          sizeDescription: product_size,
          src: PRODUCT_IMAGE_SIZES.map {|sizes|
            image_size = sizes[0]
            webp_image_size = sizes[1]

            geometry = Paperclip::Geometry.parse(image.attachment.styles[image_size].geometry)
            width = [geometry.width.round, image.attachment_width].min
            height = (image.attachment_height.to_f / image.attachment_width.to_f * width).round

            {
              width: width,
              height: height,
              url: image.attachment.url(image_size),
              urlWebp: image.attachment.url(webp_image_size),
            }
          }.uniq {|i| i[:width] },
          sortOrder: image.position,
          options: options
        }
      end

      def map_customization(product, c)
        {
          cartId: c['customisation_value']['id'],
          code: c['customisation_value']['name'],
          isDefault: false,
          title: c['customisation_value']['presentation'],
          componentTypeId: :LegacyCustomization,
          componentTypeCategory: :LegacyCustomization,
          price: (BigDecimal.new(c['customisation_value']['price'] || 0) * 100).to_i,
          strikeThroughPrice: product.discount ? (BigDecimal.new(c['customisation_value']['price'] || 0) * 100).to_i : nil,
          prices: {
            'en-AU' => (BigDecimal.new(c['customisation_value']['price'] || 0) * 100).to_i,
            'en-US' => (BigDecimal.new(c['customisation_value']['price'] || 0) * 100).to_i
          },
          isProductCode: true,
          isRecommended: false,
          type: :LegacyCustomization,
          sortOrder: c['customisation_value']['position'],
          meta: {
            image: {
              url: customization_image(c['customisation_value']),
              width: -1,
              height: -1
            }
          },
          incompatibleWith: { allOptions: [] },
        }
      end

      def map_making(product, making)
        {
          cartId: making.id,
          code: making.making_option.code,
          isDefault: false,
          title: making.making_option.name,
          componentTypeId: :Making,
          componentTypeCategory: :Making,
          price: (making.making_option.flat_price_in(current_site_version.currency)*100).to_i,
          strikeThroughPrice: product.discount ? (making.making_option.flat_price_in(current_site_version.currency)*100).to_i : nil,
          isProductCode: false,
          isRecommended: false,
          type: :Making,
          sortOrder: making.making_option.position,
          meta: {
            deliveryTimeRange: making.making_option.display_delivery_period(Time.now)
          },
          incompatibleWith: { allOptions: [] },
        }
      end

      def map_fabric(product, f)
        {
          cartId: f.fabric.id,
          code: f.fabric.name,
          isDefault: false,
          title: f.fabric.presentation,
          componentTypeId: :ColorAndFabric,
          componentTypeCategory: :ColorAndFabric,
          price: (f.price_in(current_site_version.currency) * 100).to_i,
          strikeThroughPrice: product.discount ? (f.price_in(current_site_version.currency) * 100).to_i : nil,
          prices: {
            'en-AU' => (f.price_in('AUD') * 100).to_i,
            'en-US' => (f.price_in('USD') * 100).to_i,
          },
          isProductCode: true,
          isRecommended: f.recommended,
          type: :Fabric,
          sortOrder: f.fabric.option_fabric_color_value.position, #TODO
          meta: {
            # hex: c.option_value.value,

            image: {
              url: f.fabric.image&.url(:medium),
              width: 0,
              height: 0,
            },

            colorId: f.fabric.option_value.id,
            colorCode: f.fabric.option_value.name,

            colorTitle: f.fabric.option_value.presentation,
            materialTitle: f.fabric.material,

            careDescription: CARE_DESCRIPTION,
            fabricDescription: f.description,
          },
          incompatibleWith: {},
        }
      end

      def map_color(product, c, product_fabric)
        {
          cartId: c.option_value.id,
          code: c.option_value.name,
          isDefault: false,
          title: c.option_value.presentation,
          componentTypeId: :Color,
          componentTypeCategory: :Color,
          price: c.custom ? (LineItemPersonalization::DEFAULT_CUSTOM_COLOR_PRICE * 100).to_i : 0,
          strikeThroughPrice: c.custom && product.discount ? (LineItemPersonalization::DEFAULT_CUSTOM_COLOR_PRICE * 100).to_i : 0,
          prices: {
            'en-AU' => c.custom ? (LineItemPersonalization::DEFAULT_CUSTOM_COLOR_PRICE * 100).to_i : 0,
            'en-US' => c.custom ? (LineItemPersonalization::DEFAULT_CUSTOM_COLOR_PRICE * 100).to_i : 0
          },
          isProductCode: true,
          isRecommended: !c.custom,
          type: :Color,
          meta: {
            sortOrder: c.option_value.position,
            hex: c.option_value.color_hex,
            image: c.option_value.color_image,

            careDescription: CARE_DESCRIPTION,
            fabricDescription: product_fabric,
          },
          incompatibleWith: {},
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
          strikeThroughPrice: 0,
          prices: {
            'en-AU' => 0,
            'en-US' =>  0
          },
          isProductCode: false,
          isRecommended: false,
          type: :Size,
          sortOrder: s.position,
          meta: {
            sizeUs: s.name.split("/")[0].sub("US", ""),
            sizeAu: s.name.split("/")[1].sub("AU", "")
          },
          incompatibleWith: { allOptions: [] },
        }
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
