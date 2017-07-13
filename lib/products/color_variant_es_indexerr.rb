module Products
  class ColorVariantESIndexerr
    class Helpers
      include ApplicationHelper
      include PathBuildersHelper
    end

    include ColorVariantImageDetector

    attr_reader :variants

    def self.index!
      new.call
    end

    def initialize
      'crappa'
    end

    def call
      build_variants
      push_to_index
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

      @variants = []
      product_scope.find_each do |product|
        product_price_in_us = product.price_in(us_site_version.currency)
        product_price_in_au = product.price_in(au_site_version.currency)
        #total_sales         = total_sales_for_sku(product.sku)

        color_customizable = product.color_customization
        discount           = product.discount&.amount.to_i
        product.product_color_values.recommended.active.each do |product_color_value|
          color = product_color_value.option_value

          if !product_color_value.images.present?
            next
          end

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
                  strawberry:         product.style_profile&.hour_glass,
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
                  aud:  product_price_in_au.amount,
                  usd:  product_price_in_us.amount
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
        product_index += 1
      end
      binding.pry
      @variants
    end

    def push_to_index
      #delete existing index
      binding.pry
      index_name = configatron.elasticsearch.indices.color_variants
      client = Elasticsearch::Client.new
      if client.indices.exists?(index: index_name)
        client.indices.delete index: index_name
      end

      # Tire.index index_name do
      #   create :mappings => {
      #     :document => {
      #       :properties => {
      #         :product => {
      #           :properties => {
      #             :created_at => {
      #               :format => "dateOptionalTime",
      #               :type   => "date"
      #             }
      #           }
      #         },
      #         :prices => {
      #           :properties => {
      #             :aud => { :type => 'float'},
      #             :usd => { :type => 'float'},
      #           }
      #         }
      #       }
      #     }
      #   }
      # end
      binding.pry
      # Create index w/ defined types for specific fields
      client.bulk body: variants
    end

    def product_scope
      Spree::Product.active
    end
  end
end
