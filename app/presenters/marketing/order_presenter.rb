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

    def self.build_line_items_for_production(order)
      result = order.line_items.collect do |item|
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

      # customizations is an array , currently customerio does not support nested array in json properly and they are working on it
      # that's why the json receive on customerio is not formatted correctly which lead to failed emails
      # a hacking solution is pull out all elements in customizations array to seperate elements so customerio can read correctly
      # Current output will be line_items[{... customizations: []....customizations_0: [], customizations_1: [], customizations_2: []...}, {}]

      #HACKING CUSTOMERIO
      result.each_with_index do |line_item, index|
        if line_item[:customizations][0].present?
          customizations_0 = {name: line_item[:customizations][0][:name], url: line_item[:customizations][0][:url]}
          result[index][:customizations_0] = customizations_0
        end
        if line_item[:customizations][1].present?
          customizations_1 = {name: line_item[:customizations][1][:name], url: line_item[:customizations][1][:url]}
          result[index][:customizations_1] = customizations_1
        end
        if line_item[:customizations][2].present?
          customizations_2 = {name: line_item[:customizations][2][:name], url: line_item[:customizations][2][:url]}
          result[index][:customizations_2] = customizations_2
        end
      end

      result

    end

  end
end
