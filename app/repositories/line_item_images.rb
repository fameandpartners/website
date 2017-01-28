# usage
module Repositories
  class LineItemImages
    WEDDING_ATELIER_TAXONOMY_NAME = 'Wedding Atelier'.freeze

    attr_reader :line_item

    def initialize(line_item:)
      @line_item = line_item
    end

    # @return [Repositories::Images::Template]
    def read(color_id: nil, cropped: true)
      if product_from_wedding_atelier?
        Images::Template.default
      else
        image_ostruct = Repositories::ProductImages.new(product: product).read(color_id: color_id, cropped: cropped)
        Images::Template.new(image_ostruct)
      end
    end

    private

    def product
      line_item.product
    end

    def product_from_wedding_atelier?
      product.taxons.joins(:taxonomy).exists?(['spree_taxonomies.name = ?', WEDDING_ATELIER_TAXONOMY_NAME])
    end
  end
end
