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

        def body
          {
              id:                product.id,
              name:              product.name,
              sku:               product.sku,
              price:             price.to_f,
              type:              'dresses', # Hardcoded for the moment
          }
        end
      end
    end
  end
end
