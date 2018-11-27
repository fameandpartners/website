module Marketing
  module Gtm
    module Presenter
      class LineItem < Base
        extend Forwardable

        include Rails.application.routes.url_helpers
        include PathBuildersHelper

        attr_reader :line_item, :base_url
        def_delegators :@line_item, :quantity

        # @param [Spree::LineItem] spree_line_item
        # @param [String] base_url. An absolute URL to the application's root.
        def initialize(spree_line_item:, base_url: nil)
          @line_item = spree_line_item
          @base_url  = base_url
        end

        def key
          'line_item'.freeze
        end

        def price
          line_item.price.to_f
        end

        def product_name
          line_item.style_name
        end

        def product_description
          product.description
        end

        def category
          product.taxons.first.try(:name)
        end

        def total_amount
          line_item.total.to_f
        end

        def colour
          if line_item.personalization.present?
            line_item.personalization.color
          else
            line_item.variant.try(:dress_color)
          end
        end

        def image_url
          repository_image_template = Repositories::LineItemImages.new(line_item: line_item).read(color_id: colour&.id, fabric_id: line_item.fabric&.id, fabric: line_item.fabric)
          repository_image_template.original
        end

        def product_path
          collection_product_path(product)
        end

        def product_url
          URI.join(base_url || ENV['APP_HOST'], product_path).to_s
        end

        def body
          {
            line_item_id: line_item.id,
            category:     category,
            name:         product_name,
            quantity:     quantity,
            total_amount: total_amount,
            sku:          line_item.new_sku,
            price:        price,
            product_sku:  line_item.product_sku,
            description:  product_description,
            image_url:    image_url,
            product_path: product_path,
            product_url:  product_url
          }
        end

        private

        def variant
          line_item.variant
        end

        def product
          variant.product
        end
      end
    end
  end
end
