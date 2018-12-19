module Products
  class ColorVariantsIndexer
    class Helpers
      include ApplicationHelper
      include PathBuildersHelper

      def url_options
        {}
      end
    end

    include ColorVariantImageDetector

    attr_reader :logger, :variants

    LIST_PRODUCT_IMAGE_SIZES = [[:xlarge, :webp_xlarge], [:large, :webp_large], [:medium, :webp_medium], [:small, :webp_small], [:xsmall, :webp_xsmall], [:xxsmall, :webp_xxsmall]]

    def initialize(logdev = $stdout)
      @logger = Logger.new(logdev)
      @logger.formatter = LogFormatter.terminal_formatter
      @helpers = Helpers.new
      @au_site_version = SiteVersion.find_by_permalink('au')
      @us_site_version = SiteVersion.find_by_permalink('us')
    end

    def self.index!
      new.call
    end

    def call
      logger.info('Starting Colour Reindex')
      build_variants
      push_to_index
      logger.info('Finished Colour Reindex')
    end

    private

    def build_variants
      index_name = configatron.elasticsearch.indices.color_variants

      product_index = 1

      product_count = product_scope.count
      logger.info("TOTAL PRODUCTS : #{product_count}")

      @variants = []
      product_scope.find_each do |product|
        #total_sales         = total_sales_for_sku(product.sku)

        product.curations.active.each do |curation|
          log_prefix = "Product #{product_index.to_s.rjust(3)}/#{product_count.to_s.ljust(3)} #{product.name.ljust(18)} | #{curation.pid.ljust(20)} |"

          if !curation.images.present? 
            logger.error "id  -  | #{log_prefix} No Images!"
            next
          end

          logger.info("id #{curation.id.to_s.ljust(3)} | #{log_prefix} Indexing")

          mapped = map_product(index_name, curation)

          @variants << {
            create: mapped
          } if mapped
        end
        product_index += 1
      end
      logger.info("TOTAL PRODUCTS : #{product_count}")
      @variants
    end


    def map_product(index_name, curation)
      product = curation.product
      pid = curation.pid
      images = curation.cropped_images

      product_fabric_value = curation.fabric_product
      fabric = product_fabric_value&.fabric
      product_color_value = curation.product_color_value
      color = product_color_value&.option_value || fabric&.option_value
      customizations = curation.customizations

      return nil if product_fabric_value && !product_fabric_value.active
      return nil if product_color_value && !product_color_value.active

 

      discount = product.discount&.amount.to_i
      product_price_in_us = product.price_in(@us_site_version.currency)
      product_price_in_au = product.price_in(@au_site_version.currency)

      fabric_price_in_us = 0
      fabric_price_in_au = 0

      if product_fabric_value
        fabric_price_in_us = product_fabric_value.price_in(@us_site_version.currency)
        fabric_price_in_au = product_fabric_value.price_in(@au_site_version.currency)
      elsif product_color_value
        fabric_price_in_us = product_color_value&.custom ? LineItemPersonalization::DEFAULT_CUSTOM_COLOR_PRICE : 0
        fabric_price_in_au = product_color_value&.custom ? LineItemPersonalization::DEFAULT_CUSTOM_COLOR_PRICE : 0
      end

      customizations_price_in_us = customizations.map{ |c| c['customisation_value'['price']].to_f * 100}.sum
      customizations_price_in_au = customizations.map{ |c| c['customisation_value'['price_aud']].to_f  * 100}.sum

      taxons = [
        curation.taxons || [],
        product.taxons
      ].flatten.uniq

      taxon_names = [
        taxons.map(&:permalink).map {|f| f.split('/').last },
        product.sku,
        curation.pid,
        product.category&.category,
        product.category&.subcategory,
        product.making_options.active.map(&:making_option).map(&:code),
        ProductStyleProfile::BODY_SHAPES.select{ |shape| product.style_profile.try(shape) >= 4},
        color&.name,
        fabric&.name,
        fabric&.material,
        color&.option_values_groups&.map(&:name),
      ].flatten.compact #.map(&:parameterize).map(&:underscore)

      {
        _index: index_name,
        _type: 'document',
        _id: pid,
        data: {
          id: pid,
          product: {
            id:           product.id,
            name:         product.name,
            pid:          pid,
            sku:          product.sku,
            description:  product.description,
            created_at:   product.created_at,
            available_on: product.available_on,
            is_deleted:   product.deleted_at.present?,
            is_hidden:    product.hidden?,
            position:     product.permalink,
            permalink:    product.permalink,
            master_id:    product.master.id,
            in_stock:     product.has_stock?,
            discount:     discount,
            url: @helpers.collection_product_path(curation),

            taxon_ids:          taxons.map(&:id),
            taxons:             taxon_names,
            price:              product.price.to_f,

            is_outerwear:     Spree::Product.outerwear.exists?(product.id),

            # bodyshape sorting
            apple:              product.style_profile&.apple,
            pear:               product.style_profile&.pear,
            athletic:           product.style_profile&.athletic,
            strawberry:         product.style_profile&.strawberry,
            hour_glass:         product.style_profile&.hour_glass,
            column:             product.style_profile&.column,
            petite:             product.style_profile&.petite,

            body_shape_ids:     ProductStyleProfile::BODY_SHAPES.select{ |shape| product.style_profile.try(shape) >= 4}.map{|bs| ProductStyleProfile::BODY_SHAPES.find_index(bs) },
          },
          color:  color && {
            id:             color.id,
            name:           color.name,
            presentation:   color.presentation
          },
          fabric: fabric && {
            id:             fabric.id,
            name:           fabric.name,
            presentation:   fabric.presentation
          },
         
          cropped_images: images.collect { |i| i.attachment.url(:large) },

          media: images
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

          non_sale_prices: discount > 0 ? {
            aud:  product_price_in_au.amount.to_f + fabric_price_in_au + customizations_price_in_au,
            usd:  product_price_in_us.amount.to_f + fabric_price_in_us + customizations_price_in_us
          } : nil,
          prices:  {
            aud:  (discount > 0 ? product_price_in_au.apply(product.discount).amount.to_f.round(2) : product_price_in_au.amount.to_f) + fabric_price_in_au + customizations_price_in_au,
            usd:  (discount > 0 ? product_price_in_us.apply(product.discount).amount.to_f.round(2) : product_price_in_us.amount.to_f) + fabric_price_in_us + customizations_price_in_us
          }
        }
      }
    end

    def push_to_index
      #delete existing index
      logger.info('Pushing to ElasticSearch')
      index_name = configatron.elasticsearch.indices.color_variants
      logger.info("INDEX #{index_name}")
      client = Elasticsearch::Client.new(host: configatron.es_url)
      if client.indices.exists?(index: index_name)
        client.indices.delete index: index_name
      end

      logger.info('Bulk Upload')
      # Create index w/ defined types for specific fields
      client.indices.create index: index_name,
        body:  {
            settings: {
                index: {
                    number_of_shards: 1,
                }
            },
        }
      client.bulk(index: index_name, body: @variants)
    end

    def product_scope
      Spree::Product.active
    end
  end
end
