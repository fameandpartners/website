module Repositories
  class LineItemImages
    attr_reader :line_item

    def initialize(line_item:)
      @line_item = line_item
    end

    # @return [Repositories::Images::Template]
    def read(color_id: nil, cropped: true)
      image_ostruct = Repositories::ProductImages.new(product: product).read(
        color_id: color_id,
        cropped: cropped,
        product_customizations: line_item.personalization&.customization_values,
        fabric: line_item.fabric
      )
      Images::Template.new(image_ostruct)
    end

    private
    def product
      line_item.product
    end
  end
end
