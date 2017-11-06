require 'reform'

module Forms
  class SkuUpcForm < ::Reform::Form
    property :product_id
    property :height
    property :color_name
    property :color_presentation_name
    property :sizes
    property :customization_id
    property :customization_name

    validates :product_id, :height, :color_name, :color_presentation_name, presence: true

    def available_products
      product_ids = Spree::Variant.where(deleted_at: nil).uniq(:product_id).pluck(:product_id)
      Spree::Product.where(id: product_ids)
    end

    def available_heights
      Hash[LineItemPersonalization::HEIGHTS.map { |h| [h, h.humanize] }]
    end

    def selected_product
      Spree::Product.find_by_id self.product_id
    end
  end
end
