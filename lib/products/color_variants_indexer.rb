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

    def initialize(logdev = $stdout)
      @logger = Logger.new(logdev)
      @logger.formatter = LogFormatter.terminal_formatter
    end

    def call
      logger.info('Starting Colour Reindex')

      collect_variants
      push_to_index

      logger.info('Finished Colour Reindex')
    end

    def product_scope
      Spree::Product.active
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
        product_price_in_us = product.price_in(us_site_version.currency)
        product_price_in_au = product.price_in(au_site_version.currency)
        total_sales         = total_sales_for_sku(product.sku)

        color_customizable = product.color_customization
        discount           = product.discount.try(:amount).to_i
        product.product_color_values.recommended.active.each do |product_color_value|
          color = product_color_value.option_value

          log_prefix = "Product #{product_index.to_s.rjust(3)}/#{product_count.to_s.ljust(3)} #{product.name.ljust(18)} | #{color.name.ljust(14)} |"

          unless product_color_value.images.present?
            logger.error "id  -  | #{log_prefix} No Images!"
            next
          end

          logger.info("id #{color_variant_id.to_s.ljust(3)} | #{log_prefix} Indexing")

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
              variant_skus: product.variant_skus,
              in_stock:     product.has_stock?,
              discount:     discount,
              total_sales:  total_sales,
              # added because of... really, it more simple add it here instead
              # of trying to refactor all this code
              urls: {
                en_au: helpers.descriptive_url(product, :"en-AU"),
                en_us: helpers.descriptive_url(product, :"en-US")
              },
              statistics: {
                total_sales:     total_sales,
              },
              can_be_customized:  product.can_be_customized?,
              fast_delivery:      product.fast_delivery,
              fast_making:        product.fast_making?,
              taxon_ids:          product.taxons.map(&:id),
              taxon_names:        product.taxons.map{ |tx| tx.name }.flatten,
              taxons:             product.taxons.map{ |tx| {id: tx.id, name: tx.name, permalink: tx.permalink} },
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
              aud: product_price_in_au.amount,
              usd: product_price_in_us.amount
            },
            sale_prices: {
                aud: discount > 0 ? product_price_in_au.apply(product.discount).amount : product_price_in_au.amount,
                usd: discount > 0 ? product_price_in_us.apply(product.discount).amount : product_price_in_us.amount
            }
         }

          color_variant_id += 1
        end
        product_index += 1
      end

      logger.info("TOTAL PRODUCTS : #{product_count}")
      @variants = variants
    end

    def total_sales_for_sku(sku)
      sql = %Q{
        SELECT count(v.sku) AS count
        FROM spree_line_items i
          INNER JOIN spree_variants v ON i.variant_id = v.id
          INNER JOIN spree_orders o ON i.order_id = o.id
        WHERE v.sku = '#{sku}'
          AND o.completed_at IS NOT NULL
        GROUP BY sku
      }
      value = ActiveRecord::Base.connection.select_value(sql)

      value.to_i
    end

    def push_to_index
      logger.info('Pushing to ElasticSearch')
      logger.info("INDEX #{index_name}")
      index = get_index

      logger.info('Delete')
      index.delete

      logger.info('Create')

      # Create index w/ defined types for specific fields
      # TODO: Move work with index to model with all fields definitions
      Tire.index index.name do
        create :mappings => {
          :document => {
            :properties => {
              :product => {
                :properties => {
                  :created_at => {
                    :format => "dateOptionalTime",
                    :type   => "date"
                  }
                }
              },
              :prices => {
                :properties => {
                  :aud => { :type => 'float'},
                  :usd => { :type => 'float'},
                }
              }
            }
          }
        }
      end
      binding.pry
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
