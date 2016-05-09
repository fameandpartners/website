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
          start = Time.now
          csv_attr = order.attributes
          # o = Spree::Order.find(csv_attr['order_id'])
          # li = Spree::LineItem.find(csv_attr['line_item_id'])
          # op = OrderPresenter.new(o)
          # lip = LineItemPresenter.new(li, op)
          csv << [
            csv_attr['order_state'],
            csv_attr['order_number'],
            csv_attr['line_item_id'],
            csv_attr['total_items'],
            csv_attr['completed_at_char'],
            '', # lip.fast_making? ? "TRUE" : '',
            csv_attr['projected_delivery_date_char'],
            csv_attr['tracking_number'],
            csv_attr['shipment_date'],
            csv_attr['fabrication_state'],
            '', # lip.sku,,
            csv_attr['style'],
            csv_attr['style_name'] || 'Missing Variant',
            csv_attr['factory'],
            csv_attr['color'] || 'Unknown Color',
            (csv_attr['size'] || 'Unknown Size')  + " (#{csv_attr['site_version']})",
            csv_attr['height'] || LineItemPersonalization::DEFAULT_HEIGHT,
            '', # lip.customisations.collect(&:first).join('|'),
            '', # lip.promo_codes.join('|'),
            csv_attr['email'],
            csv_attr['customer_notes'],
            "#{csv_attr['user_first_name']} #{csv_attr['user_last_name']}",
            csv_attr['customer_phone_number'],
            '', # lip.wrapped_order.shipping_address,
            '', # lip.order.return_requested?,
            '', # lip.return_action,
            '', # lip.return_details,
            '', # lip.price,
            csv_attr['currency']
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
        :sku,
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

  end
end
