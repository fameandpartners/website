module Products
  class ColorVariantsIndexer
    class Helpers
      include ApplicationHelper
      include PathBuildersHelper
    end

    include ColorVariantImageDetector

    attr_reader :logger, :variants

    def initialize(logdev = $stdout)
      @logger = Logger.new(logdev)
      @logger.formatter = LogFormatter.terminal_formatter
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
      helpers = Helpers.new
      index_name = configatron.elasticsearch.indices.color_variants
      au_site_version = SiteVersion.find_by_permalink('au')
      us_site_version = SiteVersion.find_by_permalink('us')

      color_variant_id = 1
      product_index = 1

      product_count = product_scope.count
      logger.info("TOTAL PRODUCTS : #{product_count}")

      @variants = []
      product_scope.find_each do |product|
        product_price_in_us = product.price_in(us_site_version.currency)
        product_price_in_au = product.price_in(au_site_version.currency)
        #total_sales         = total_sales_for_sku(product.sku)

        color_customizable = product.color_customization
        discount           = product.discount&.amount.to_i

        if product.fabric_products.empty?
          product.product_color_values.recommended.active.each do |product_color_value|
            color = product_color_value.option_value
            log_prefix = "Product #{product_index.to_s.rjust(3)}/#{product_count.to_s.ljust(3)} #{product.name.ljust(18)} | #{color.name.ljust(14)} |"

            if !product_color_value.images.present? 
              logger.error "id  -  | #{log_prefix} No Images!"
              next
            end

            logger.info("id #{color_variant_id.to_s.ljust(3)} | #{log_prefix} Indexing")

            @variants << {
              create: {
                _index: index_name,
                _type: 'document',
                _id: color_variant_id,
                data: {
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
                    position:     product.permalink,
                    permalink:    product.permalink,
                    master_id:    product.master.id,
                    variant_skus: product.variant_skus,
                    in_stock:     product.has_stock?,
                    discount:     discount,
                    urls: {
                      en_au: helpers.descriptive_url(product, :"en-AU"),
                      en_us: helpers.descriptive_url(product, :"en-US")
                    },

                    can_be_customized:  product.can_be_customized?,
                    fast_delivery:      product.fast_delivery,
                    fast_making:        product.fast_making?,
                    taxon_ids:          product.taxons.map(&:id),
                    taxon_names:        product.taxons.map{ |tx| tx.name }.flatten,
                    taxons:             product.taxons.map{ |tx| {id: tx.id, name: tx.name, permalink: tx.permalink} },
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
                    color:              color_customizable

                  },
                  color:  {
                    id:             color.id,
                    name:           color.name,
                    presentation:   color.presentation
                  },
                  images: product_color_value.images.map do |image|
                    {
                      large: image.attachment.url(:large)
                    }
                  end,
                  cropped_images: cropped_images_for(product_color_value),

                  prices: {
                    aud:  product_price_in_au.amount.to_f,
                    usd:  product_price_in_us.amount.to_f
                  },
                  sale_prices:  {
                    aud:  discount > 0 ? product_price_in_au.apply(product.discount).amount : product_price_in_au.amount,
                    usd:  discount > 0 ? product_price_in_us.apply(product.discount).amount : product_price_in_us.amount
                  }
                }
              }
            }
            color_variant_id += 1
          end
        else
            product.fabric_products.each do |product_fabric_value|
            color = product_fabric_value.fabric.option_value
            fabric = product_fabric_value.fabric
            log_prefix = "Product #{product_index.to_s.rjust(3)}/#{product_count.to_s.ljust(3)} #{product.name.ljust(18)} | #{color.name.ljust(14)} |"

            if !product_fabric_value.images.present? 
              logger.error "id  -  | #{log_prefix} No Images!"
              next
            end

            logger.info("id #{color_variant_id.to_s.ljust(3)} | #{log_prefix} Indexing")

            @variants << {
              create: {
                _index: index_name,
                _type: 'document',
                _id: color_variant_id,
                data: {
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
                    position:     product.permalink,
                    permalink:    product.permalink,
                    master_id:    product.master.id,
                    variant_skus: product.variant_skus,
                    in_stock:     product.has_stock?,
                    discount:     discount,
                    urls: {
                      en_au: helpers.descriptive_url(product, :"en-AU"),
                      en_us: helpers.descriptive_url(product, :"en-US")
                    },

                    can_be_customized:  product.can_be_customized?,
                    fast_delivery:      product.fast_delivery,
                    fast_making:        product.fast_making?,
                    taxon_ids:          product.taxons.map(&:id),
                    taxon_names:        product.taxons.map{ |tx| tx.name }.flatten,
                    taxons:             product.taxons.map{ |tx| {id: tx.id, name: tx.name, permalink: tx.permalink} },
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
                    color:              color_customizable

                  },
                  color:  {
                    id:             color.id,
                    name:           color.name,
                    presentation:   color.presentation
                  },
                  fabric:       {
                    id:             fabric.id,
                    name:           fabric.name,
                    presentation:   fabric.presentation
                  },
                  images: product_fabric_value.images.map do |image|
                    {
                      large: image.attachment.url(:large)
                    }
                  end,
                  cropped_images: cropped_images_for(product_fabric_value),

                  prices: {
                    aud:  product_price_in_au.amount.to_f,
                    usd:  product_price_in_us.amount.to_f
                  },
                  sale_prices:  {
                    aud:  discount > 0 ? product_price_in_au.apply(product.discount).amount : product_price_in_au.amount,
                    usd:  discount > 0 ? product_price_in_us.apply(product.discount).amount : product_price_in_us.amount
                  }
                }
              }
            }
            color_variant_id += 1
          end
        end
        product_index += 1
      end
      logger.info("TOTAL PRODUCTS : #{product_count}")
      @variants
    end

    def push_to_index
      #delete existing index
      logger.info('Pushing to ElasticSearch')
      index_name = configatron.elasticsearch.indices.color_variants
      logger.info("INDEX #{index_name}")
      client = Elasticsearch::Client.new(host: configatron.es_url || 'localhost:9200')

      if client.indices.exists?(index: index_name)
        client.indices.delete index: index_name
      end

      logger.info('Bulk Upload')
      # Create index w/ defined types for specific fields
      client.bulk(index: index_name,body: @variants)
    end

    def product_scope
      Spree::Product.active
    end
  end
end
