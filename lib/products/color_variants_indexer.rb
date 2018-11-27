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

    LIST_PRODUCT_IMAGE_SIZES = [:original, :xlarge, :large, :medium, :small, :xsmall, :xxsmall]

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

      color_variant_id = 1
      product_index = 1

      product_count = product_scope.count
      logger.info("TOTAL PRODUCTS : #{product_count}")

      @variants = []
      product_scope.find_each do |product|
        #total_sales         = total_sales_for_sku(product.sku)

        if product.fabric_products.empty?
          product.product_color_values.active.each do |product_color_value|
            color = product_color_value.option_value
            log_prefix = "Product #{product_index.to_s.rjust(3)}/#{product_count.to_s.ljust(3)} #{product.name.ljust(18)} | #{color.name.ljust(14)} |"

            if !product_color_value.images.present? 
              logger.error "id  -  | #{log_prefix} No Images!"
              next
            end

            logger.info("id #{color_variant_id.to_s.ljust(3)} | #{log_prefix} Indexing")

            @variants << {
              create: map_product(index_name, color_variant_id, product, nil, color, nil, product_color_value)
            }
            color_variant_id += 1
          end
        else
          product.fabric_products.active.each do |product_fabric_value|
            color = product_fabric_value.fabric.option_value
            fabric = product_fabric_value.fabric
            log_prefix = "Product #{product_index.to_s.rjust(3)}/#{product_count.to_s.ljust(3)} #{product.name.ljust(18)} | #{color.name.ljust(14)} |"

            if !product_fabric_value.images.present? 
              logger.error "id  -  | #{log_prefix} No Images!"
              next
            end

            logger.info("id #{color_variant_id.to_s.ljust(3)} | #{log_prefix} Indexing")

            @variants << {
              create: map_product(index_name, color_variant_id, product, fabric, color, product_fabric_value, nil)
            }
            color_variant_id += 1
          end
        end
        product_index += 1
      end
      logger.info("TOTAL PRODUCTS : #{product_count}")
      @variants
    end


    def map_product(index_name, id, product, fabric, color, product_fabric_value, product_color_value)
      pid = Spree::Product.format_new_pid(product.sku, fabric&.name || color.name, [])

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

      curations = Curation.includes(:taxons).all
      curation = curations
        .first {|c| c.pid == pid }

      taxons = [
        curation&.taxons || [],
        product.taxons
      ].flatten.uniq


      taxon_names = [
        taxons.map(&:permalink).map {|f| f.split('/').last },
        product.sku,
        pid,
        product.category.category,
        product.category.subcategory,
        product.making_options.active.map(&:making_option).map(&:code),
        ProductStyleProfile::BODY_SHAPES.select{ |shape| product.style_profile.try(shape) >= 4},
        color.name,
        fabric&.name,
        fabric&.material,
        color.option_values_groups.map(&:name),
      ].flatten.compact #.map(&:parameterize).map(&:underscore)

      images = cropped_images_for(product_fabric_value || product_color_value)

      {
        _index: index_name,
        _type: 'document',
        _id: pid,
        data: {
          id: pid,
          product: {
            id:           product.id,
            name:         product.name,
            pid:          Spree::Product.format_new_pid(product.sku, fabric&.name || color.name, []),
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
            urls: {
              en_au: @helpers.descriptive_url(product, :"en-AU"),
              en_us: @helpers.descriptive_url(product, :"en-US")
            },
            url: @helpers.collection_product_path(product, color: (fabric&.name || color&.name)),

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
          color:  {
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
              src: LIST_PRODUCT_IMAGE_SIZES.map {|image_size|
                if image_size == :original
                  width = image.attachment_width
                  height = image.attachment_height
                else
                  geometry = Paperclip::Geometry.parse(image.attachment.styles[image_size].geometry)
                  width = geometry.width
                  height = geometry.height
                end
    
                {
                  name: image_size,
                  width: width,
                  height: height,
                  url: image.attachment.url(image_size),
                }
              }.select { |i| i[:width] <= image.attachment_width},
              sortOrder: image.position
            }
          end,

          non_sale_prices: discount > 0 ? {
            aud:  product_price_in_au.amount.to_f + fabric_price_in_au,
            usd:  product_price_in_us.amount.to_f + fabric_price_in_us
          } : nil,
          prices:  {
            aud:  (discount > 0 ? product_price_in_au.apply(product.discount).amount.to_f.round(2) : product_price_in_au.amount.to_f) + fabric_price_in_au,
            usd:  (discount > 0 ? product_price_in_us.apply(product.discount).amount.to_f.round(2) : product_price_in_us.amount.to_f) + fabric_price_in_us
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
