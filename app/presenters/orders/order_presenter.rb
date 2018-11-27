require 'forwardable'

module Orders
  class OrderPresenter

    extend Forwardable

    def_delegators :spree_order,
                   :products,
                   :display_total,
                   :currency,
                   :customer_notes,
                   :id,
                   :email,
                   :number,
                   :completed_at,
                   :name,
                   :first_name,
                   :shipments,
                   # TODO: replace addresses with the related decorators where needed.
                   # Nickolay, 03 Jan 2017
                   :billing_address,
                   :shipping_address,
                   :site_version,
                   :state,
                   :to_param,
                   :display_promotion_total,
                   :shipment,
                   :completed?,
                   :updated_at,
                   :payment_state,
                   :fabrication_status,
                   :shipped?,
                   :order_return_requested?,
                   :returnable?,
                   :item_count,
                   :return_type,
                   :vwo_type

    attr_reader :spree_order, :items

    def initialize(order, items = nil)
      @spree_order = order
      @items = items || order.line_items
      @items = @items&.sort { |x,y| x.stock.to_s <=> y.stock.to_s }
    end

    alias_method :customer_notes?, :customer_notes

    # TODO: this should be just billing_address
    def decorated_billing_address
      @decorated_billing_address ||= Orders::AddressPresenter.new(spree_order.billing_address)
    end

    # TODO: this should be just shipping_address
    def decorated_shipping_address
      @decorated_shipping_address ||= Orders::AddressPresenter.new(spree_order.shipping_address)
    end

    def line_items
      items.map(&decorate)
    end

    private def decorate
      -> (line_item) { LineItemPresenter.new(line_item, self) }
    end

    def one_item?
      line_items.count == 1
    end

    def total_items
      items.sum(&:quantity)
    end

    def country_code
      spree_order.shipping_address.country.iso
    end
    
    def promo_codes
      @promo_codes ||= \
        spree_order.adjustments.where("originator_type = 'Spree::PromotionAction'").collect do |adj|
          "[#{adj.originator.promotion.code}] #{adj.originator.promotion.name}"
        end
    end

    def taxes
      spree_order.adjustments.eligible.tax.map { |tax| TaxPresenter.new(spree_adjustment: tax, spree_order: spree_order) }
    end

    def promotion?
      promo_codes.any?
    end

    def phone_number
      spree_order.try(:billing_address).try(:phone).presence || 'No Phone'
    end

    def shipping_address
      spree_order.try(:shipping_address).presence || 'No Shipping Address'
    end

    def tracking_number
      spree_order.shipments.first.try(:tracking)
    end

    def return_requested?
      return_request.present?
    end

    def delivery_discount
      "$#{('%.2f' %((spree_order.item_total * 0.1).to_f).round(2)).to_s}"
    end

    def return_request
      @return_request ||= OrderReturnRequest.where(:order_id => spree_order.id).first
    end

    def missing_image_to_nil(url)
      url.include?('missing.png') ? nil : url
    end

    def extract_line_items
      self.line_items.collect do |item|
        {
          style_name:            item.style_name,
          style_num:             item.style_number,
          sku:                   item.sku,
          extended_style_number: item.extended_style_number,
          line_item_id:          item.id,
          product_number:        item.product_number,
          size:                  item.size,
          adjusted_size:         item.country_size,
          color:                 item.colour_name,
          fabric:                item.fabric ? item.fabric.material : nil,
          height:                item.height,
          quantity:              item.quantity,
          factory:               item.factory.name,
          deliver_date:          item.projected_delivery_date.to_s,
          express_making:        item.making_options.present? ? item.making_options.map { |option| option.name.upcase }.join(', ') : "",
          image_url:             item.image? ? item.image_url : '',
          total_price:           item.price.to_s,
          discount:              item.item.product.discount.to_s
        }.merge(
           # Convert each element of the customisations array
           # to an explicit hash key and child hash.
           #
           # Customizations is an array , currently customerio does not support nested array in json properly and they are working on it
           # that's why the json receive on customerio is not formatted correctly which lead to failed emails
           # a hacking solution is pull out all elements in customizations array to seperate elements so customerio can read correctly
           # Current output will be line_items[{... customizations: []....customizations_0: [], customizations_1: [], customizations_2: []...}, {}]
           #
           # e.g. Where we would like to use an array;
           # :customizations=>[{:name=>"N/A", :url=>nil}, {:name=>"Cool", :url=>nil} ]
           # we must use merge a hash to the original result
           # :customizations_0=>{:name=>"N/A", :url=>nil},
           # :customizations_1=>{:name=>"Cool", :url=>nil},
          item.customisations.each_with_index.map do |(name, image_url), idx|
            ["customizations_#{idx}".to_sym, {name: name, url: missing_image_to_nil(image_url.to_s)}]
          end.to_h
        )
      end
    end
  end
end
