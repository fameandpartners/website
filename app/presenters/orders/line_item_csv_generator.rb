require 'csv'

module Orders
  class LineItemCsvGenerator
    attr_reader :orders, :query_params

    def initialize(orders, query_params = {})
      @orders = orders
      @query_params = query_params
    end

    def filename
      parts = ['fp_orders']
      parts << Date.parse(query_params[:created_at_gt]).strftime('from_%Y-%m-%d') if query_params[:created_at_gt].present?
      parts << Date.parse(query_params[:created_at_lt]).strftime('to_%Y-%m-%d')   if query_params[:created_at_lt].present?
      parts << (query_params.fetch(:completed_at_not_null) { false } == '1' ? 'only_complete' : 'all_states')
      parts << 'generated_at'
      parts << DateTime.now.to_s(:file_timestamp)
      parts.join('_') << '.csv'
    end

    def headers
      en_headers.collect { |k| "#{k} #{cn_headers[k]}" }
    end

    def to_csv
      CSV.generate(headers: true) do |csv|
        csv << headers
        orders.map do |order|
          line_attr = order.attributes
          csv << [
            line_attr['order_state'],
            line_attr['order_number'],
            line_attr['line_item_id'],
            line_attr['total_items'],
            line_attr['completed_at_char'],
            line_attr['fast_making'].present? ? "TRUE" : '',
            line_attr['projected_delivery_date_char'],
            line_attr['tracking_number'],
            line_attr['shipment_date'],
            line_attr['fabrication_state'],
            line_attr['style'],
            line_attr['style_name'] || 'Missing Variant',
            line_attr['factory'] || 'Unknown',
            color_name(line_attr),
            (line_attr['size'] || 'Unknown Size')  + " (#{line_attr['site_version']})",
            line_attr['height'] || LineItemPersonalization::DEFAULT_HEIGHT,
            customization_values(line_attr),
            line_attr['promo_codes'],
            line_attr['email'],
            line_attr['customer_notes'],
            customer_name(line_attr),
            line_attr['customer_phone_number'] || 'No Phone',
            shipping_address(line_attr).present? ? shipping_address(line_attr) : 'No Shipping Address',
            line_attr['return_action_details'].present? ? 'true' : 'false',
            line_attr['return_action_details'].try(:split, '/').try(:[], 0),
            line_attr['return_action_details'].try(:split, '/').try(:[], 1),
            price(line_attr),
            line_attr['currency']
          ]
        end
      end
    end

  private

    def en_headers
      [
        :order_state,
        :order_number,
        :line_item,
        :total_items,
        :completed_at,
        :express_making,
        :projected_delivery_date,
        :tracking_number,
        :shipment_date,
        :fabrication_state,
        :style,
        :style_name,
        :factory,
        :color,
        :size,
        :height,
        :customisations,
        :promo_codes,
        :email,
        :customer_notes,
        :customer_name,
        :customer_phone_number,
        :shipping_address,
        :return_request,
        :return_action,
        :return_details,
        :price,
        :currency
      ]
    end

    def cn_headers
      {
        order_number:            '(订单号码)',
        completed_at:            '(订单日期)',
        express_making:          '(快速决策)',
        projected_delivery_date: '(要求出厂日期)',
        tracking_number:         '(速递单号)',
        style:                   '(款号)',
        factory:                 '(工厂)',
        color:                   '(颜色)',
        size:                    '(尺寸)',
        customisations:          '(特殊要求)',
        customer_name:           '(客人名字)',
        customer_phone_number:   '(客人电话)',
        shipping_address:        '(客人地址)'
      }
    end

    def customer_name(line_attr)
      "#{line_attr['user_first_name']} #{line_attr['user_last_name']}"
    end

    def shipping_address(line_attr)
      "#{line_attr['address1']} #{line_attr['address2']} #{line_attr['city']} #{line_attr['state']} #{line_attr['zipcode']} #{line_attr['country']}"
    end

    def price(line_attr)
      line_attr['price'].to_f + line_attr['personalization_price'].to_f + line_attr['making_options_price'].to_f
    end

    def color_name(line_attr)
      line_attr['color'] || 'Unknown Color'
    end

    def customization_values(line_attr)
      if line_attr['personalization'].present?
        values = YAML.load(line_attr['customization_value_ids'])
        customs = values.present? ? CustomisationValue.where(id: values).pluck(:presentation) : []
        customs << ["Custom Color: #{color_name(line_attr)}"] unless line_attr['custom_color']
        customs
      else
        ['N/A']
      end.join('|')
    end

  end
end
