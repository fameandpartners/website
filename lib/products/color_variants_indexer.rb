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
    

      taxons = [
        curation.taxons || [],
        product.taxons,
        fabric&.taxons || []
      ].flatten.uniq

      taxon_names = [
        taxons.map(&:permalink).map {|f| f.split('/').last },
        taxons.map(&:permalink),
        product.sku,
        curation.pid,
        product.category&.category,
        product.category&.subcategory,
        product.making_options.active.map(&:making_option).map(&:code),
        color&.name,
        fabric&.name,
        fabric&.material
      ].flatten.compact #.map(&:parameterize).map(&:underscore)

      {
        _index: index_name,
        _type: 'document',
        _id: pid,
        data: {
          id: pid,
          product: {
            id:           product.id,
            name:         curation.name || product.name,
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
            .select { |x| x.attachment_content_type.present? }
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
            aud:  curation.price_in(@au_site_version.currency).to_f,
            usd:  curation.price_in(@us_site_version.currency).to_f
          } : nil,
          prices:  {
            aud:  curation.discount_price_in(@au_site_version.currency).to_f,
            usd:  curation.discount_price_in(@us_site_version.currency).to_f
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
