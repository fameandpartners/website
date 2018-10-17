module Marketing
  class LineItemPresenter < Orders::Shared::LineItemPresenter

  def_delegators :@item,
                   :quantity,
                   :making_options_text,
                   :options_text

    def sku
      variant.sku.blank? ? product.sku : variant.sku
    end

    def product_name
      item.style_name
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

    def product
      variant.product
    rescue StandardError => e
      NewRelic::Agent.notice_error(e, custom_params: { order_number: wrapped_order.number })
    end
  end
end
