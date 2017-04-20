module Products
  class ColorVariantESIndexer
    class Helpers
      include ApplicationHelper
      include PathBuildeersHelper
    end

    def self.index!

    end


    private

    def self.build_variants
      helpers = Helpers.new
      au_site_version = SiteVersion.find_by_permalink('au')
      us_site_version = SiteVersion.find_by_permalink('us')

      color_variant_id = 1
      product_index = 1

      product_count = product_scope.count

      variants = []
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
              taxon_names:        product.taxons.map( |tx| tx.name }.flatten,
              taxons:             product.taxons.map{ |tx| {id: tx.id, name: tx.name, perma

            }

          }
        end
      end
    end

    def product_scope
      Spree::Product.active
    end
  end
end
