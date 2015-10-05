require 'forwardable'

module Orders
  class OrderPresenter

    extend Forwardable

    def_delegators :@order,
                   :products,
                   :display_total,
                   :customer_notes,
                   :id,
                   :number,
                   :completed_at,
                   :name,
                   :first_name,
                   :shipments,
                   :site_version,
                   :state,
                   :to_param,
                   :has_fast_making_items?

    attr_reader :order, :items

    def initialize(order, items = nil)
      @order = order
      @items = items || order.line_items
    end

    alias_method :customer_notes?, :customer_notes

    def line_items
      items.collect { |i| LineItemPresenter.new(i, self) }
    end

    def one_item?
      line_items.count == 1
    end

    def product
      products.first
    end

    def total_items
      items.sum &:quantity
    end

    def country_code
      order.shipping_address.country.iso
    end

    def projected_delivery_date
      return unless order.completed?
      order.projected_delivery_date.try(:to_date) || Policies::OrderProjectedDeliveryDatePolicy.new(order).delivery_date.try(:to_date)
    end

    def promo_codes
      @promo_codes ||= order.adjustments.where("originator_type = 'Spree::PromotionAction'").collect { |adj|
        "[#{adj.originator.promotion.code}] #{adj.originator.promotion.name}"
      }
    end

    def fast_making_promo?
      promo_codes.any?{ |code| code.downcase.include?('birthdaygirl') }
    end

    def promotion?
      promo_codes.any?
    end

    def phone_number
      order.try(:billing_address).try(:phone) || 'No Phone'
    end

    def shipping_address
      order.try(:shipping_address) || 'No Shipping Address'
    end

    def tracking_number
      if order.shipments.any?
        order.shipments.first.tracking
      end
    end

    def return_requested?
      return_request.present?
    end

    def return_request
      @return_request ||= OrderReturnRequest.where(:order_id => order.id).first
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
        }.merge(
           # Convert each element of the customisations array
           # to an explicit hash key and child hash.
           # <INSERT Customer.io COMMENTS>
           #
           # e.g. Where we would like to use an array;
           # :customizations=>[{:name=>"N/A", :url=>nil}, {:name=>"Cool", :url=>nil} ]
           # we must use merge a hash to the original result
           # :customisation_0=>{:name=>"N/A", :url=>nil},
           # :customisation_1=>{:name=>"Cool", :url=>nil},
          item.customisations.each_with_index.map do |(name, image_url), idx|
            ["customizations_#{idx}".to_sym, {name: name, url: image_url}]
          end.to_h
        )
      end

      result

    end

  end
end
