require 'forwardable'

module Marketing
  class LineItemPresenter
    extend Forwardable

    def_delegators :@item,
                   :variant,
                   :quantity,
                   :making_options_text,
                   :options_text

    attr_reader :item, :wrapped_order

    def initialize(item, wrapped_order)
      @item          = item
      @wrapped_order = wrapped_order
    end

    def sku
      variant.sku.blank? ? product.sku : variant.sku
    end

    def product_name
      product.name
    end

    def category_name
      product.taxons.first.try(:name)
    end

    def total_amount
      item.total.to_f
    end

    def display_amount
      item.display_amount.to_s
    end

    def variant_display_amount
      variant.display_amount.to_s
    end

    def size
      if item.personalization.present?
        item.personalization.size.try(:name)
      else
        item.variant.try(:dress_size).try(:name)
      end

      # || 'Unknown Size'
    end

    def color
      if item.personalization.present?
        item.personalization.color.try(:name) || 'Unknown Color'
      else
        item.variant.try(:dress_color).try(:name) || 'Unknown Color'
      end
    end

    def height
      item.personalization.present? ? item.personalization.height : LineItemPersonalization::DEFAULT_HEIGHT
    end

    def product
      variant.product
    rescue StandardError => e
      NewRelic::Agent.notice_error(e, custom_params: { order_number: wrapped_order.number })
    end
  end
end
