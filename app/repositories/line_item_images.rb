module Repositories
  class LineItemImages
    # WEDDING_ATELIER_TAXONOMY_NAME = 'Wedding Atelier'.freeze

    attr_reader :line_item

    def initialize(line_item:)
      @line_item = line_item
    end

    # @return [Repositories::Images::Template]
    def read(color_id: nil, cropped: true)
      # if product_from_wedding_atelier?
      #   wedding_attrs = image_for_wedding_atelier
      #   Images::Template.new(wedding_attrs)
      # else
        image_ostruct = Repositories::ProductImages.new(product: product).read(color_id: color_id, cropped: cropped)
        Images::Template.new(image_ostruct)
      # end
    end

    private

    # TODO: related to "primitive obsession" reported at the `WeddingAtelier::EventDress` model. This conversion shouldn't be here
    # def image_for_wedding_atelier
    #   customization_values = line_item&.personalization&.customization_values
    #   images = WeddingAtelier::EventDress.new({
    #     product_id: line_item.product.id,
    #     color_id:   line_item&.personalization&.color_id,
    #     fit_id:     customization_values&.by_type(:fit)&.first&.id,
    #     style_id:   customization_values&.by_type(:style)&.first&.id,
    #     fabric_id:  customization_values&.by_type(:fabric)&.first&.id,
    #     length_id:  customization_values&.by_type(:length)&.first&.id
    #   }).images

    #   {
    #     original: images.dig(:real, :large)&.first,
    #     large:    images.dig(:front, :normal),
    #     xlarge:   images.dig(:front, :large),
    #     small:    images.dig(:front, :moodboard)
    #   }
    # end

    def product
      line_item.product
    end

    # def product_from_wedding_atelier?
    #   product.taxons.joins(:taxonomy).exists?(['spree_taxonomies.name = ?', WEDDING_ATELIER_TAXONOMY_NAME])
    # end
  end
end
