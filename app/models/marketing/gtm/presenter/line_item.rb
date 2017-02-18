module Marketing
  module Gtm
    module Presenter
      class LineItem < Base
        extend Forwardable

        include Rails.application.routes.url_helpers
        include PathBuildersHelper

        attr_reader :line_item, :request
        def_delegators :@line_item, :quantity

        def initialize(spree_line_item:, action_dispatch_request: nil)
          @line_item = spree_line_item
          @request   = action_dispatch_request
        end

        def key
          'line_item'.freeze
        end

        def sku
          CustomItemSku.new(line_item).call
        end

        def variant_sku
          VariantSku.new(variant).call
        end

        def product_sku
          product.sku
        end

        def product_name
          product.name
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

        def image_url
          repository_image_template = Repositories::LineItemImages.new(line_item: line_item).read
          repository_image_template.original
        end

        def product_url
          if request
            collection_product_url(product)
          else
            collection_product_path(product)
          end
        end

        def body
          {
            category:     category,
            name:         product_name,
            quantity:     quantity,
            total_amount: total_amount,
            sku:          sku,
            variant_sku:  variant_sku,
            product_sku:  product_sku,
            description:  product_description,
            image_url:    image_url,
            product_url:  product_url,
          }
        end

        private

        def variant
          line_item.variant
        end

        def product
          variant.product
        end

        def default_url_options
          { protocol: request&.protocol, host: request&.host }
        end
      end
    end
  end
end
