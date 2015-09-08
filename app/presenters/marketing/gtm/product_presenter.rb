module Marketing
  module Gtm
    class ProductPresenter
      include ActionView::Helpers::SanitizeHelper

      attr_reader :product

      def initialize(product_presenter:)
        @product = product_presenter
      end

      def key
        'product'.freeze
      end

      def price
        product.price.amount
      end

      def price_with_discount
        if (discount = product.discount)
          product.price.apply(discount).amount
        else
          price
        end
      end

      def discount_percent
        discount = product.discount ? product.discount.amount : 0
        discount.to_s
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
        {
            original: image.original,
            xlarge:   image.xlarge,
            large:    image.large,
            small:    image.small
        }
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
            name:              product.name,
            brand:             'Fame & Partners', # Hardcoded for the moment
            sku:               product.sku,
            price:             price,
            priceWithDiscount: price_with_discount,
            discountPercent:   discount_percent,
            type:              'dresses',         # Hardcoded for the moment
            currency:          currency,
            colors:            colors,
            selectedColor:     selected_color,
            categories:        categories,
            image:             featured_image_urls,
            images:            all_images,
            description:       description,
            expressMaking:     product.fast_making,
            sizes:             sizes
        }
      end
    end
  end
end
