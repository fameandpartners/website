require 'forwardable'

module Marketing
  class OrderPresenter
    extend Forwardable

    def_delegators :@order,
                   :number,
                   :currency

    attr_reader :order, :items

    def initialize(order)
      @order = order
      @items = order.line_items
    end

    def line_items
      items.collect { |i| LineItemPresenter.new(i, self) }
    end

    def total_amount
      order.total.to_f
    end

    def taxes_amount
      order.adjustments.tax.sum(:amount).to_f
    end

    def shipping_amount
      order.adjustments.shipping.sum(:amount).to_f
    end

    def self.build_line_items(order)
      order.line_items.collect do |item|
        {
          sku:                    item.variant.sku,
          name:                   item.variant.product.name,
          making_options_text:    item.making_options_text,
          options_text:           item.options_text,
          quantity:               item.quantity,
          variant_display_amount: item.variant.display_amount,
          display_amount:         item.display_amount
        }
      end
    end

    def self.build_adjustments(order)
      if order.adjustments.present?
        order.adjustments.eligible.collect do |adjustments_item|
          {
            label:          adjustments_item.label,
            display_amount: adjustments_item.display_amount
          }
        end
      else
        []
      end
    end

    def self.build_additional_products_info(additional_products_info)
      if additional_products_info.present?
        additional_products_info.collect do |info_item|
          {
            product: info_item.product,
            email:   info_item.email,
            phone:   info_item.phone,
            state:   info_item.state
          }
        end
      else
        []
      end
    end

    def self.build_line_items_for_production(order)
      order.line_items.collect do |item|
        {
          style_num:        item.style_number,
          size:             item.country_size,
          adjusted_size:    item.make_size,
          color:            item.colour_name,
          quantity:         item.quantity,
          factory:          item.factory,
          deliver_date:     order.projected_delivery_date,
          express_making:   item.making_options.present? ? item.making_options.map{|option| option.name.upcase }.join(', ') : "",
          customizations:   item.customisations.collect do |name, image_url| {name: name,url: image_url} end,
          image_url:        item.image? ? item.image_url : ''
        }
      end
    end

  end
end
