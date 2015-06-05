module Products
  class ColorVariantsIndexer
    class Helpers
      include ApplicationHelper
      include PathBuildersHelper
    end

    extend ColorVariantImageDetector

    def self.index!
      helpers = Helpers.new
      au_site_version = SiteVersion.find_by_permalink('au')
      us_site_version = SiteVersion.find_by_permalink('us')
      color_variant_id = 1

      index = Tire.index(configatron.elasticsearch.indices.color_variants)
      index.delete
      index.create

      Spree::Product.all.each do |product|
        color_ids = product.variants.active.map do |variant|
          variant.option_values.colors.map(&:id)
        end.flatten.uniq

        color_customizable = %w(yes y).include?(product.property('color_customization').to_s.downcase.strip)
        discount = product.discount.try(:amount).to_i

        product.product_color_values.each do |product_color_value|
          color = product_color_value.option_value

          next unless color_ids.include?(color.id)
          next unless product_color_value.images.present?

          index.store(
            id: color_variant_id,
            product: {
              id:           product.id,
              name:         product.name,
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
              can_be_customized: product.can_be_customized?,
              fast_delivery: product.fast_delivery,
              fast_making: product.fast_making,
              is_surryhills: helpers.is_surryhills?(product),
              taxon_ids: product.taxons.map(&:id),
              price: product.price.to_f,

              # bodyshape sorting
              apple: product.style_profile.try(:apple),
              pear: product.style_profile.try(:pear),
              athletic: product.style_profile.try(:athletic),
              strawberry: product.style_profile.try(:strawberry),
              hour_glass: product.style_profile.try(:hour_glass),
              column: product.style_profile.try(:column),
              petite: product.style_profile.try(:petite),
              color_customizable: color_customizable
            },
            color: {
              id: color.id,
              name: color.name,
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
          )

          color_variant_id += 1
        end
      end

      index.refresh
    end
  end
end
