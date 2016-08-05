require 'forwardable'

module Marketing
  class LineItemPresenter
    extend Forwardable

    def_delegators :@item,
                   :variant,
                   :quantity,
                   :making_options_text,
                   :options_text,
                   :personalization

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

    def current_size
      size.split('/').detect {|s| s.downcase.include? @wrapped_order.site_version } || 'Unknown Size'
    rescue
      'Unknown Size'
    end

    def size
      if personalization.present?
        personalization.size.try(:name)
      else
        variant.try(:dress_size).try(:name)
      end
    end

    def color
      if personalization.present?
        personalization.color.try(:name) || 'Unknown Color'
      else
        variant.try(:dress_color).try(:name) || 'Unknown Color'
      end
    end

    def height
      personalization.present? ? personalization.height : LineItemPersonalization::DEFAULT_HEIGHT
    end

    def customisation
      if personalization.present?
        personalization.customization_values.collect(&:presentation).join(' / ')
      end
    end

    def product
      variant.product
    rescue StandardError => e
      NewRelic::Agent.notice_error(e, custom_params: { order_number: wrapped_order.number })
    end
  end
end
