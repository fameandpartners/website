class Bridesmaid::BoughtAdditionalProductsResource
  attr_reader :order

  def initialize(options = {})
    @order = options[:order]
  end

  def read
    return [] if bridesmaid_party_events.blank?
    bought_additional_products
  rescue
    []
  end

  private

    def bridesmaid_party_events
      @order.user.try(:bridesmaid_party_events)
    end

    def line_items_ids
      order.line_items.map(&:id)
    end

    def additional_products
      @additional_products ||= begin
        bridesmaid_party_events.map do |event|
          event.additional_products || []
        end.flatten
      end
    end

    def bought_additional_products
      additional_products.map do |item|
        if item[:line_item_id].present? && line_items_ids.include?(item[:line_item_id])
          # {:name=>:consierge_service, email: email, :line_item_id=>10467, :phone=>"123123123", :suburb_state=>"state"}]
          FastOpenStruct.new({
            product: line_item_details(item[:line_item_id], item[:name]),
            email: item[:email],
            phone: item[:phone],
            state: item[:suburb_state]
          })
        else
          nil
        end
      end.compact
    end

    def line_item_details(line_item_id, name)
      variant = Spree::LineItem.find(line_item_id).variant
      product = variant.product
      "#{ product.name } (#{ variant.sku })"
    rescue
      name
    end
end
