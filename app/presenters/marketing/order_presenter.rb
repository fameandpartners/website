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
      line_items = []
      order.line_items.each do |item|
        line_item = {}
        line_item[:sku]                    = item.variant.sku
        line_item[:name]                   = item.variant.product.name
        line_item[:making_options_text]    = item.making_options_text
        line_item[:options_text]           = item.options_text
        line_item[:quantity]               = item.quantity
        line_item[:variant_display_amount] = item.variant.display_amount
        line_item[:display_amount]         = item.display_amount
        line_items << line_item
      end
      line_items
    end

    def self.build_adjustments(order)
      adjustments = []
      order.adjustments.eligible.each do |adjustments_item|
        adjustment = {}
        adjustment[:label]          = adjustments_item.label
        adjustment[:display_amount] = adjustments_item.display_amount
        adjustments << adjustment
      end
      adjustments
    end

    def self.build_additional_products_info(additional_products_info)
      additional_products_info_result = []
      if @additional_products_info.present?
        info = {}
        @additional_products_info.each do |info_item|
          info[:product] = info_item.product
          info[:email] = info_item.email
          info[:phone] = info_item.phone
          info[:state] = info_item.state
        end
        additional_products_info_result << info
      end
      additional_products_info_result
    end

    def self.build_line_items_for_production(order)
      line_items = []
      order.line_items.each do |item|
        line_item = {}
        line_item[:style_num]                   = item.style_number
        line_item[:size]                        = item.country_size
        line_item[:adjusted_size]               = item.make_size
        line_item[:color]                       = item.colour_name
        line_item[:quantity]                    = item.quantity
        line_item[:factory]                     = item.factory
        line_item[:deliver_date]                = order.projected_delivery_date
        line_item[:express_making]              = ""
        if item.making_options.present?
          line_item[:express_making] = item.making_options.map{|option| option.name.upcase }.join(', ')
        end

        customizations = []

        item.customisations.each do |name, image_url|
          item_customization = {}
          item_customization[:name] = name
          item_customization[:url]  = image_url
          customizations << item_customization
        end

        line_item[:customizations] = customizations

        if item.image?
          line_item[:image_url] = item.image_url
        end

        line_items << line_item
      end
      line_items
    end

  end
end
