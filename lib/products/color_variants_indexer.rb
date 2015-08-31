module Products
  class ColorVariantsIndexer
    class Helpers
      include ApplicationHelper
      include PathBuildersHelper
    end

    include ColorVariantImageDetector

    def self.index!
      new.call
    end

    attr_reader :logger, :variants

    def initialize
      @logger = Logger.new($stdout)
      @logger.formatter = LogFormatter.terminal_formatter
    end

    def call
      logger.info('Starting Colour Reindex')

      collect_variants
      push_to_index

      logger.info('Finished Colour Reindex')
    end

    def product_scope
      Spree::Product
    end

    def collect_variants
      helpers = Helpers.new
      au_site_version = SiteVersion.find_by_permalink('au')
      us_site_version = SiteVersion.find_by_permalink('us')

      color_variant_id = 1
      product_index    = 1

      product_count  = product_scope.count
      logger.info("TOTAL PRODUCTS : #{product_count}")

      variants = []
      product_scope.find_each do |product|
        logger.info("PRODUCT #{product_index}/#{product_count} #{product.name}")

        active_color_ids = product.variants.active.map do |variant|
          variant.option_values.colors.map(&:id)
        end.flatten.uniq

        color_customizable = product.color_customization
        discount           = product.discount.try(:amount).to_i

        product.product_color_values.each do |product_color_value|
          color = product_color_value.option_value

          unless active_color_ids.include?(color.id)
            logger.warn "#{color.name} Not in active Colours"
            next
          end
          unless product_color_value.images.present?
            logger.warn "#{color.name} NO IMAGES"
            next
          end

          logger.info("PRODUCT #{product_index}/#{product_count} #{product.name} | #{color_variant_id} Colour #{color.name}")

          variants << {
            id: color_variant_id,
            product: {
              id:           product.id,
              name:         product.name,
              sku:          product.sku,
              description:  product.description,
              created_at:   product.created_at,
              available_on: product.available_on,
              is_deleted:   product.deleted_at.present?,
              is_hidden:    product.hidden?,
              position:     product.position,
              permalink:    product.permalink,
              master_id:    product.master.id,
              in_stock:     product.has_stock?,
              discount:     discount,

              # added because of... really, it more simple add it here instead
              # of trying to refactor all this code
              urls: {
                en_au: helpers.descriptive_url(product, :"en-AU"),
                en_us: helpers.descriptive_url(product, :"en-US")
              },
              can_be_customized:  product.can_be_customized?,
              fast_delivery:      product.fast_delivery,
              fast_making:        product.fast_making,
              taxon_ids:          product.taxons.map(&:id),
              price:              product.price.to_f,

              # Outerwear
              is_outerwear:       Spree::Product.outerwear.exists?(product.id),

              # bodyshape sorting
              apple:              product.style_profile.try(:apple),
              pear:               product.style_profile.try(:pear),
              athletic:           product.style_profile.try(:athletic),
              strawberry:         product.style_profile.try(:strawberry),
              hour_glass:         product.style_profile.try(:hour_glass),
              column:             product.style_profile.try(:column),
              petite:             product.style_profile.try(:petite),
              color_customizable: color_customizable
            },
            color: {
              id:           color.id,
              name:         color.name,
              presentation: color.presentation
            },
            images: product_color_value.images.map do |image|
              {
                large: image.attachment.url(:large)
              }
            end,
            cropped_images: cropped_images_for(product_color_value),
            prices: {
              aud: product.zone_price_for(au_site_version).amount,
              usd: product.zone_price_for(us_site_version).amount
            }
         }

          color_variant_id += 1
        end
        product_index += 1
      end

      logger.info("TOTAL PRODUCTS : #{product_count}")
      @variants = variants
    end

    def push_to_index
      logger.info('Pushing to ElasticSearch')
      logger.info("INDEX #{index_name}")
      index = get_index

      logger.info('Delete')
      index.delete

      logger.info('Create')
      index.create

      logger.info('Bulk Upload')
      index.bulk_store(variants)
      logger.info('Refresh')

      index.refresh
    end

    def get_index
      Tire.index(index_name)
    end

    def index_name
      configatron.elasticsearch.indices.color_variants
    end
  end
end
