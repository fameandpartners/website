module Marketing
  module Gtm
    module Presenter
      class Product < Base
        include ActionView::Helpers::SanitizeHelper

        attr_reader :product

        def initialize(product_presenter:)
          @product = product_presenter
        end

        def key
          'product'.freeze
        end

        def price
          product.price&.amount.to_f.round(2)
        end

        def variants
          if product.variants.first
            [Variant.new(spree_variant: product.variants.first)&.body]
          end
          []
          # product.variants.map { |variant| Variant.new(spree_variant: variant).body }
        end

        def price_with_discount
          product.price_amount.to_f.round(2)
        end

        def discount_percent
          product.discount&.amount
        end

        def currency
          product.price.currency
        end

        def colors
          default_colors = product.colors.default
          extra_colors   = product.colors.extra
          (default_colors + extra_colors).map(&:name)
        end

        def selected_color
          product.color_name
        end

        def categories
          product.taxons.map(&:permalink)
        end

        def description
          strip_tags(product.description)
        end

        def sizes
          default_sizes = product.sizes.default
          extra_sizes   = product.sizes.extra
          (default_sizes + extra_sizes).map(&:presentation)
        end

        def featured_image_urls
          image = product.featured_image

          if image
            {
              original: image.original,
              xlarge:   image.xlarge,
              large:    image.large,
              small:    image.small
            }
          else
            {}
          end
        end

        def all_images
          product.images.map do |image|
            {
                original: image.original,
                xlarge:   image.xlarge,
                large:    image.large,
                small:    image.small,
            }
          end
        end

        def body
          {
              id:                product.id,
              name:              product.name,
              brand:             'Fame & Partners', # Hardcoded for the moment
              sku:               product.sku,
              price:             price.to_f,
              priceWithDiscount: price_with_discount,
              discountPercent:   discount_percent,
              type:              'dresses', # Hardcoded for the moment
              currency:          currency,
              colors:            colors,
              selectedColor:     selected_color,
              categories:        categories,
              image:             featured_image_urls,
              images:            all_images,
              description:       description,
              expressMaking:     product.fast_making,
              sizes:             sizes,
              variants:          variants
          }
        end
      end
    end
  end
end
